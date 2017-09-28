class OrchestratorClient::Command

  def initialize(https)
    @https = https
  end

  def task(options = {})
    raise ArgumentError, 'Must pass options as a hash' unless options.is_a? Hash
    @https.post("command/task", options)
  end

  def deploy(options = {})
    raise ArgumentError, 'Must pass options as a hash' unless options.is_a? Hash
    @https.post("command/deploy", options)
  end

  def stop(job_number)
    data = {"job" => "#{job_number}"}
    @https.post("command/stop",data)
  end
end
