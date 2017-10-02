require 'net/https'
require 'uri'
require 'json'
require 'openssl'

class OrchestratorClient
  require 'orchestrator_client/error'
  require 'orchestrator_client/command'
  require 'orchestrator_client/jobs'
  require 'orchestrator_client/job'

  attr_accessor :config, :token

  def initialize(settings = {})

    @config = { 'token_path'  => File.join(Dir.home, '.puppetlabs', 'token'),
                'api_version' => 'v1'
    }.merge(settings)

    if @config['token']
      @token = @config['token']
    else
      @token = File.read(@config['token_path'])
    end

    if @config['service-url'].nil?
      raise OrchestratorClient::ConfigError.new("'service-url' is required in config")
    end

     @config['service-url'] += '/' if @config['service-url'] !~ /\/$/
     @config['service-url'] += 'orchestrator/v1/'

    if @config['cacert'].nil?
      raise  OrchestratorClient::ConfigError.new("'cacert' is required in config")
    end
  end

  def make_uri(path)
    URI.parse("#{config['service-url']}#{path}")
  end

  def create_http(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.ssl_version = :TLSv1
    http.ca_file = config['cacert']
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http
  end

  def get(location)
    uri = make_uri(location)
    https = create_http(uri)
    req = Net::HTTP::Get.new(uri)
    req['Content-Type'] = "application/json"
    req.add_field('X-Authentication', token)
    res = https.request(req)

    if res.code != "200"
      raise OrchestratorClient::ApiError.make_error_from_response(res)
    end

    JSON.parse(res.body)
  end

  def post(location, body)
    uri = make_uri(location)
    https = create_http(uri)

    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = "application/json"
    req.add_field('X-Authentication', token)
    req.body = body.to_json
    res = https.request(req)

    if res.code != "202"
      raise OrchestratorClient::ApiError.make_error_from_response(res)
    end

    JSON.parse(res.body)
  end

  def command
    @command ||= OrchestratorClient::Command.new(self)
  end

  def jobs
    @jobs ||= OrchestratorClient::Jobs.new(self)
  end

  def new_job(options, type = :deploy)
    OrchestratorClient::Job.new(self, options, type)
  end

  def run_task(options)
    job = OrchestratorClient::Job.new(self, options, :task)
    job.start
    job.wait
    job.nodes['items']
  end

  def root
    get(url)
  end
end
