require 'spec_helper'

describe OrchestratorClient::Command do

  before :each do
    @url_base = "https://orchestrator.example.lan:8143"

    @config = {
      'service-url'              => @url_base,
      'cacert' => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
      'token'               => 'myfaketoken',
    }

    @orchestrator = OrchestratorClient.new(@config)

    @scope = {'nodes' => ['example.com']}
    @deploy_opts = { 'scope' => @scope }
    @task_opts = {'scope' => @scope,
                  'task' => 'my::task',
                  'params' => {}}
  end

  describe '#newobject' do
    it 'takes an orchestrator url and OrchestratorClient object and returns a OrchestratorClient::Command object' do
      expect(@orchestrator.command).to be_an_instance_of OrchestratorClient::Command
    end
  end

  describe '#deploy' do
    it 'takes an environment and issues a deploy command' do
      response = "{\n  \"job\" : {\n    \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/1\",\n    \"name\" : \"1\"\n  }\n}"

      stub_request(:post, "https://orchestrator.example.lan:8143/orchestrator/v1/command/deploy").
        with(:body => @deploy_opts.to_json,
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 202, :body => response, :headers => {})

      expect(@orchestrator.command.deploy(@deploy_opts)).to be_an_instance_of Hash
    end
  end

  describe '#task' do
    it 'takes an environment and issues a deploy command' do
      response = "{\n  \"job\" : {\n    \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/1\",\n    \"name\" : \"1\"\n  }\n}"

      stub_request(:post, "https://orchestrator.example.lan:8143/orchestrator/v1/command/task").
        with(:body => @task_opts.to_json,
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 202, :body => response, :headers => {})

      expect(@orchestrator.command.task(@task_opts)).to be_an_instance_of Hash
    end
  end

  describe '#stop' do
    it 'takes a valid job number and stops the job' do
      response = "{\n  \"job\" : {\n    \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/1\",\n    \"name\" : \"1\",\n    \"nodes\" : {\n      \"finished\" : 3\n    }\n  }\n}"

      stub_request(:post, "https://orchestrator.example.lan:8143/orchestrator/v1/command/stop").
        with(:body => "{\"job\":\"1\"}",
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 202, :body => response, :headers => {})

      expect(@orchestrator.command.stop(1)).to be_an_instance_of Hash
    end
  end
end
