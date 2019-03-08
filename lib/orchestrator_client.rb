require 'net/https'
require 'uri'
require 'json'
require 'openssl'
require 'faraday'

class OrchestratorClient
  require 'orchestrator_client/error'
  require 'orchestrator_client/command'
  require 'orchestrator_client/jobs'
  require 'orchestrator_client/job'
  require 'orchestrator_client/config'

  attr_accessor :config
  attr_reader :http

  def initialize(overrides, load_files=false)
    @config = Config.new(overrides, load_files)
    @config.validate
    @http = create_http(config.root_url)
  end

  def create_http(root_url)
    Faraday.new(url: root_url) do |f|
      f.headers['Content-Type'] = 'application/json'
      f.headers['X-Authentication'] = config.token
      f.headers['User-Agent'] = config['User-Agent']
      f.ssl['ca_file'] = config['cacert']
      f.ssl['version'] = :TLSv1_2
      # Do not use net-http-persistent on windows
      if !!File::ALT_SEPARATOR
        f.adapter :net_http
      else
        f.adapter :net_http_persistent, pool_size: 5 do |http|
          http.idle_timeout = 30
        end
      end
    end
  end

  def get(location)
    res = http.get(location)

    if res.status != 200
      raise OrchestratorClient::ApiError.make_error_from_response(res)
    end

    JSON.parse(res.body)
  end

  def post(location, body)
    res = http.post(location, body.to_json)

    unless Set.new([202, 200]).include? res.status
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
