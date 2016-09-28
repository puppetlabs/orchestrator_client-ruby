require 'net/https'
require 'uri'
require 'json'
require 'openssl'

class Orchestrator_api
  require 'orchestrator_api/error'
  require 'orchestrator_api/command'
  require 'orchestrator_api/jobs'
  require 'orchestrator_api/job'
  require 'orchestrator_api/environments'

  attr_accessor :config, :token

  def initialize(settings = {})

    #Stringify the hash so it can be merged
    settings = Hash[settings.map { |k, v| [k.to_s, v] }]

    @config = { 'token_path'  => File.join(Dir.home, '.puppetlabs', 'token'),
                'api_version' => 'v1'
    }.merge(settings)

    if @config['token']
      @token = @config['token']
    else
      @token = File.read(@config['token_path'])
    end

    if @config['service-url'].nil?
      raise "Configuration error: 'service-url' must specify the server running the Orchestration services and cannot be empty"
    end
    if @config['cacert'].nil?
      raise "Configuration error: 'cacert' must specify a path to the CA certificate used for communications with the server and cannot be empty"
    end
  end

  def url
    "/orchestrator/#{config['api_version']}"
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

  def get(endpoint)
    uri = make_uri(endpoint)
    https = create_http(uri)

    req = Net::HTTP::Get.new(uri.request_uri)
    req['Content-Type'] = "application/json"
    req.add_field('X-Authentication', token)
    res = https.request(req)

    if res.code != "200"
      raise Orchestrator_api::Error.make_error_from_response(res)
    end

    JSON.parse(res.body)
  end

  def post(endpoint, body)
    uri = make_uri(endpoint)
    https = create_http(uri)

    req = Net::HTTP::Post.new(uri.request_uri)
    req['Content-Type'] = "application/json"
    req.add_field('X-Authentication', token)
    req.body = body.to_json
    res = https.request(req)

    if res.code != "202"
      raise Orchestrator_api::Error.make_error_from_response(res)
    end

    JSON.parse(res.body)
  end

  def command
    @command ||= Orchestrator_api::Command.new(self, url)
  end

  def environments
    @environments ||= Orchestrator_api::Environments.new(self, url)
  end

  def jobs
    @jobs ||= Orchestrator_api::Jobs.new(self, url)
  end

  def new_job(options)
    Orchestrator_api::Job.new(self, options)
  end

  def root
    get(url)
  end
end
