
class OrchestratorClient::ConfigError < RuntimeError
end

class OrchestratorClient::ApiError < RuntimeError
  attr_reader :data, :code

  def initialize(data,code)
    @code = code
    @data = data
    super(data['msg'])
  end

  def self.make_error_from_response(res)
    begin
      data = JSON.parse(res.body)
    rescue
      return OrchestratorClient::BadResponse.new("Response body was not valid JSON: #{res.body}")
    end
    code = res.status

    case data['kind']
    when 'puppetlabs.validators/validation-error'
      ValidationError.new(data, code)
    when 'puppetlabs.orchestrator/unknown-job'
      UnknownJob.new(data, code)
    when 'puppetlabs.orchestrator/unknown-environment'
      UnknownEnvironment.new(data, code)
    when 'puppetlabs.orchestrator/empty-environment'
      EmptyEnvironment.new(data, code)
    when 'puppetlabs.orchestrator/empty-target'
      EmptyTarget.new(data, code)
    when 'puppetlabs.orchestrator/dependency-cycle'
      DependencyCycle.new(data, code)
    when 'puppetlabs.orchestrator/puppetdb-error'
      PuppetdbError.new(data, code)
    when 'puppetlabs.orchestrator/query-error'
      QueryError.new(data, code)
    when 'puppetlabs.orchestrator/unknown-error'
      UnknownError.new(data, code)
    when 'puppetlabs.orchestrator/not-permitted'
      UnauthorizedError.new(data, code)
    else
      OrchestratorClient::ApiError.new(data, code)
    end
  end
end

class OrchestratorClient::ApiError::ValidationError < OrchestratorClient::ApiError; end
class OrchestratorClient::ApiError::UnknownJob < OrchestratorClient::ApiError; end
class OrchestratorClient::ApiError::UnknownEnvironment < OrchestratorClient::ApiError; end
class OrchestratorClient::ApiError::EmptyEnvironment < OrchestratorClient::ApiError; end
class OrchestratorClient::ApiError::EmptyTarget < OrchestratorClient::ApiError; end
class OrchestratorClient::ApiError::DependencyCycle < OrchestratorClient::ApiError; end
class OrchestratorClient::ApiError::PuppetdbError < OrchestratorClient::ApiError; end
class OrchestratorClient::ApiError::QueryError < OrchestratorClient::ApiError; end
class OrchestratorClient::ApiError::UnknownError < OrchestratorClient::ApiError; end
class OrchestratorClient::ApiError::UnauthorizedError < OrchestratorClient::ApiError; end
class OrchestratorClient::BadResponse < RuntimeError; end
