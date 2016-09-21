
class Orchestrator_api::Error < Exception

  def initialize(data,code)
    @code = code
    @kind = data['kind']
    @details = data['details']
    super(data['msg'])
  end

  def self.make_error_from_response(res)
    begin
      data = JSON.parse(res.body)
    rescue
      return EndpointError.new("An unspecified error has occurred with the Orchestrator API")
    end
    code = res.code

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
      EndpointError.new("An unspecified error has occurred with the Orchestrator API")
    end
  end
end

class Orchestrator_api::Error::ValidationError < Orchestrator_api::Error; end
class Orchestrator_api::Error::UnknownJob < Orchestrator_api::Error; end
class Orchestrator_api::Error::UnknownEnvironment < Orchestrator_api::Error; end
class Orchestrator_api::Error::EmptyEnvironment < Orchestrator_api::Error; end
class Orchestrator_api::Error::EmptyTarget < Orchestrator_api::Error; end
class Orchestrator_api::Error::DependencyCycle < Orchestrator_api::Error; end
class Orchestrator_api::Error::PuppetdbError < Orchestrator_api::Error; end
class Orchestrator_api::Error::QueryError < Orchestrator_api::Error; end
class Orchestrator_api::Error::UnknownError < Orchestrator_api::Error; end
class Orchestrator_api::Error::UnauthorizedError < Orchestrator_api::Error; end
class Orchestrator_api::Error::EndpointError < Exception; end
