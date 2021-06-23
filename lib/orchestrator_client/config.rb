require 'json'
require 'orchestrator_client/version'

class OrchestratorClient::Config

  def initialize(overrides = nil, load_files=false)
    @overrides = overrides || {}
    @load_files = load_files
  end

  def load_file(path)
    File.open(path) {|f| JSON.parse(f.read)['options']}
  end

  def puppetlabs_root
    "/etc/puppetlabs"
  end

  def global_conf
    File.join(puppetlabs_root, 'client-tools', 'orchestrator.conf')
  end

  def user_root
    File.join(Dir.home, '.puppetlabs')
  end

  def user_conf
    File.join(user_root, 'client-tools', 'orchestrator.conf')
  end

  def cacert
    "#{puppetlabs_root}/puppet/ssl/certs/ca.pem"
  end

  def defaults
    { 'cacert' => cacert,
      'token-file' => File.join(user_root, 'token'),
      'User-Agent' => "OrchestratorRubyClient/#{OrchestratorClient::VERSION}",
      'job-poll-interval' => 1,
      'job-poll-timeout' => 1000,
    }
  end

  def load_config
    config = defaults
    if @load_files
      if File.exists?(global_conf) && File.readable?(global_conf)
        config = config.merge(load_file(global_conf))
      end

      if @overrides['config-file']
        config = config.merge(load_file(@overrides['config-file']))
      elsif File.exists?(user_conf) && File.readable?(user_conf)
        config = config.merge(load_file(user_conf))
      end
    end

    config.merge!(@overrides)

    %w[token-file cacert].each do |f|
      config[f] = File.expand_path(config[f]) if config[f]
    end
    config
  end

  def validate
    if config['service-url'].nil?
      raise OrchestratorClient::ConfigError.new("'service-url' is required in config")
    end

    begin
      service_url = URI.parse(config['service-url'])
      unless service_url.kind_of?(URI::HTTP) || service_url.kind_of?(URI::HTTPS)
        raise OrchestratorClient::ConfigError.new("'#{config['service-url']}' is an invalid service-url")
      end
    rescue URI::InvalidURIError
      raise OrchestratorClient::ConfigError.new("'#{config['service-url']}' is an invalid service-url")
    end

    if config['cacert'].nil?
      raise  OrchestratorClient::ConfigError.new("'cacert' is required in config")
    end

    validate_file('cacert', config['cacert'])
  end

  def config
    @config ||= load_config
  end

  def overrides_only
    @config = @overrides
  end

  def load_token
    if @config['token']
      @config['token']
    else
      validate_file('token-file', config['token-file'])
      token = File.open(config['token-file']) { |f| f.read.strip }
      # If the token file contains illegal characters
      if token =~ URI::UNSAFE
        raise OrchestratorClient::ConfigError.new("token-file '#{config['token-file']}' contains illegal characters")
      end
      @config['token'] = token
      @config['token']
    end
  end

  def token
    @token ||= load_token
  end

  def root_url
    unless @root_url
     url = @config['service-url']
     url += '/' if url !~ /\/$/
     url += 'orchestrator/v1/'
     @root_url = url
    end
    @root_url
  end

  def [](key)
    @config[key]
  end

  def validate_file(type, path)
    stat = File.stat(path)
    if !stat.readable?
      OrchestratorClient::ConfigError.new("#{type} '#{path}' is unreadable")
    elsif !stat.file?
      OrchestratorClient::ConfigError.new("#{type} '#{path}' is not a file")
    end
  rescue Errno::ENOENT
    raise OrchestratorClient::ConfigError.new("#{type} '#{path}' does not exist")
  end
end
