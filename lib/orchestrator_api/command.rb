class Orchestrator_api::Command

  def initialize(https, api_url_base)
    @https = https
    @api_url_base = api_url_base
  end

  def deploy(environment, options = {})
    raise ArgumentError, 'Must pass options as a hash' unless options.is_a? Hash
    options['environment'] = environment
    @https.post("#{@api_url_base}/command/deploy", options)
  end

  def stop(job_number)
    data = {"job" => "#{job_number}"}
    @https.post("#{@api_url_base}/command/stop",data)
  end
end
