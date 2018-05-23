require 'net/https'
require 'uri'
require 'json'
require 'openssl'

class OrchestratorClient
  require 'orchestrator_client/error'
  require 'orchestrator_client/command'
  require 'orchestrator_client/jobs'
  require 'orchestrator_client/job'
  require 'orchestrator_client/config'

  attr_accessor :config

  def initialize(overrides, load_files=false)
    @config = Config.new(overrides, load_files)
    @config.validate
  end

  def make_uri(path)
    URI.parse("#{config.root_url}#{path}")
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
    req['User-Agent'] = @config['User-Agent']
    req.add_field('X-Authentication', @config.token)
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
    req['User-Agent'] = @config['User-Agent']
    req.add_field('X-Authentication', @config.token)
    req.body = body.to_json
    res = https.request(req)

    unless Set.new(["202", "200"]).include? res.code
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
    if options[:plan_job] || options['plan_job']
      type = :plan_task
    else
      type = :task
    end
    job = OrchestratorClient::Job.new(self, options, type)
    job.start
    job.wait
    job.nodes['items']
  end

  def root
    get(url)
  end
end
