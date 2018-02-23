require 'spec_helper'

describe OrchestratorClient::ApiError do

  it 'is an child class of Exception' do
    expect(OrchestratorClient::ApiError).to be <= Exception
  end

  it 'exposes data' do
    data = {'msg' => 'oops',
            'kind' => 'mistake',
            'details' => { 'key' => 'val' } }
    expect(OrchestratorClient::ApiError.new(data, '400').data).to  eq(data)
  end

  %w(ValidationError UnknownJob UnknownEnvironment EmptyEnvironment EmptyTarget DependencyCycle PuppetdbError QueryError UnknownError UnauthorizedError).each do |name|
    describe "::#{name}" do
      klass = OrchestratorClient::ApiError.const_get(name)
      it "should be a child class of OrchestratorClient::ApiError" do
        expect(klass).to be <= OrchestratorClient::ApiError
      end
    end
  end

  describe "::make_error_from_response" do
    before(:all) do
      class FakeResponse
        attr_reader :code, :body
        def initialize(error)
          @code = '400'
          @body = "{\"kind\":\"#{error}\"}"
        end
      end
    end

    %w(
      puppetlabs.validators/validation-error:ValidationError
      puppetlabs.orchestrator/unknown-job:UnknownJob
      puppetlabs.orchestrator/unknown-environment:UnknownEnvironment
      puppetlabs.orchestrator/empty-target:EmptyTarget
      puppetlabs.orchestrator/dependency-cycle:DependencyCycle
      puppetlabs.orchestrator/puppetdb-error:PuppetdbError
      puppetlabs.orchestrator/query-error:QueryError
      puppetlabs.orchestrator/unknown-error:UnknownError
      puppetlabs.orchestrator/not-permitted:UnauthorizedError
    ).each do |item|
      error = item.split(':')
      it "creates an exception based on an \"#{error.first}\" error response from the server" do
        res = FakeResponse.new(error.first)
        klass = OrchestratorClient::ApiError.const_get(error[1])
        expect( OrchestratorClient::ApiError.make_error_from_response(res) ).to be_an_instance_of klass
      end
    end

    it "creates an OrchestratorClient::ApiError exception when the response from the server isn't parsable JSON" do
      res = FakeResponse.new("makesforunparsablejson\"")
      expect( OrchestratorClient::ApiError.make_error_from_response(res)).to be_an_instance_of OrchestratorClient::BadResponse
    end

    it "creates an OrchestratorClient::ApiError exception when it does not understand the error from the service" do
      res = FakeResponse.new('notarealerror')
      expect( OrchestratorClient::ApiError.make_error_from_response(res)).to be_an_instance_of OrchestratorClient::ApiError
    end
  end
end
