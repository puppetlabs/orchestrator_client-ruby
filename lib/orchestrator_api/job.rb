class Orchestrator_api::Job

  attr_accessor :job_name, :options

  def validate_scope
    scope = @options['scope']
    if scope.empty
      Raise ArgumentError 'Scope cannot be empty'
    elif  scope['whole_environment']
      puts 'Deprecation Warning: Whole environment behavior may not be stable'
    end
  end

  # Should this be a class method that starts a job?
  def initialize(client, options = {})
    @client = client
    @options = options
  end

  def start
    result = @client.command.deploy(options)
    @job_name = result['job']['name']
  end

  def stop
    unless job_name
      Raise ArgumentError "Job name not known to stop"
    end
  end

  def assert_started?
    Raise ArgumentError "Job is not yet started" unless @job_name
  end

  def get_details
    assert_started?
    @details = @client.jobs.details(@job_name)
  end

  def details
    @details ||= get_details
  end
end
