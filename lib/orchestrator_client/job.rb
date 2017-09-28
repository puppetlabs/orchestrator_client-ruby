class OrchestratorClient::Job

  DONE_STATES = ['stopped', 'finished', 'failed']
  DONE_EVENTS = ['job_aborted', 'job_finished']

  attr_accessor :job_name, :options, :job_id

  def validate_scope
    scope = @options['scope']
    if scope.empty
      Raise ArgumentError 'Scope cannot be empty'
    elif  scope['whole_environment']
      puts 'Deprecation Warning: Whole environment behavior may not be stable'
    end
  end

  def initialize(client, options = {}, type=:deploy)
    @client = client
    @options = options
    @type = type
  end

  def start
    case @type
    when :deploy
      result = @client.command.deploy(options)
    when :task
      result = @client.command.task(options)
    end

    @job_name = result['job']['name']
    @job_id = result['job']['id']
    @next_event=nil
    @job_name
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

  def report
    @client.jobs.report(@job_name)
  end

  def nodes
    @client.jobs.nodes(@job_name)
  end

  # A poll the events endpoint yielding each event
  def each_event
    finished = false
    start = nil
    while !finished
      events = @client.jobs.events(@job_name)
      start = events['next-events']['event']
      if events['items'].empty?
        sleep 1
      else
        events['items'].each do |event|
          finished = true if DONE_EVENTS.include?(event['type'])
          yield event
        end
      end
    end
  end

  def wait(timeout=1000)
    counter = 0
    while counter < timeout
      get_details
      if DONE_STATES.include?(details['state'])
        return report
      end
      sleep 1
      counter += 1
    end
  end
end
