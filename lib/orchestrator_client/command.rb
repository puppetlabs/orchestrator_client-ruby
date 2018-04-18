class OrchestratorClient::Command

  def initialize(https)
    @https = https
  end

  def deploy(options = {})
    raise ArgumentError, 'Must pass options as a hash' unless options.is_a? Hash
    @https.post("command/deploy", options)
  end

  def plan_start(options = {})
    raise ArgumentError, 'Must pass options as a hash' unless options.is_a? Hash
    @https.post("command/plan_start", options)
  end

  def plan_finish(options = {})
    raise ArgumentError, 'Must pass options as a hash' unless options.is_a? Hash
    @https.post("command/plan_finish", options)
  end

  def plan_task(options = {})
    raise ArgumentError, 'Must pass options as a hash' unless options.is_a? Hash
    @https.post("command/plan_task", options)
  end

  def stop(job_number)
    data = {"job" => "#{job_number}"}
    @https.post("command/stop",data)
  end

  def task(options = {})
    raise ArgumentError, 'Must pass options as a hash' unless options.is_a? Hash
    @https.post("command/task", options)
  end
end
