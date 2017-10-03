require 'json'

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
    }
  end

  def load_config
    config = defaults
    if @load_files
      if File.exists?(global_conf) && file.readable?(global_conf)
        config = config.merge(load_file(global_conf))
      end

      if @overrides['config-file']
        config = config.merge(load_file(@overrides['config-file']))
      elsif File.exists?(user_conf) && File.readable?(user_conf)
        config = config.merge(load_file(user_conf))
      end
    end

    config.merge(@overrides)
  end

  def validate
    if config['service-url'].nil?
      raise OrchestratorClient::ConfigError.new("'service-url' is required in config")
    end

    if config['cacert'].nil?
      raise  OrchestratorClient::ConfigError.new("'cacert' is required in config")
    end
  end

  def config
    @config ||= load_config
  end

  def overrides_only
    @config = @overrides
  end

  def load_token
    @config['token'] || File.open(config['token-file']) { |f| f.read }
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
end
