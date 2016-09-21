require 'spec_helper'

describe Orchestrator_api::Command do

  before :each do
    @url_base = "https://master.puppetlabs.vm:8143/orchestrator/v1"

    config = {
      'server'              => 'orchestrator.example.lan',
      'ca_certificate_path' => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
      'port'                => '8143',
      'api_version'         => 'v1',
      'token'               => 'myfaketoken'
    }

    @orchestrator = Orchestrator_api.new(config)
  end

  describe '#newobject' do
    it 'takes an orchestrator url and Orchestrator_api object and returns a Orchestrator_api::Command object' do
      expect(@orchestrator.command).to be_an_instance_of Orchestrator_api::Command
    end
  end

  describe '#deploy' do
    it 'takes an environment and issues a deploy command' do
      response = "{\n  \"job\" : {\n    \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/1\",\n    \"name\" : \"1\"\n  }\n}"

      stub_request(:post, "https://orchestrator.example.lan:8143/orchestrator/v1/command/deploy").
        with(:body => "{\"environment\":\"production\"}",
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 202, :body => response, :headers => {})

      expect(@orchestrator.command.deploy('production')).to be_an_instance_of Hash
    end

    it 'takes an environment and hash of additional details' do
      response = "{\n  \"job\" : {\n    \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/1\",\n    \"name\" : \"1\"\n  }\n}"

      stub_request(:post, "https://orchestrator.example.lan:8143/orchestrator/v1/command/deploy").
        with(:body => "{\"scope\":{\"nodes\":[\"node1.example.lan\",\"node2.example.lan\"]},\"environment\":\"production\"}",
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 202, :body => response, :headers => {})

      details = {
        'scope' => {
          'nodes' => ['node1.example.lan','node2.example.lan']
        }
      }
      expect(@orchestrator.command.deploy('production',details)).to be_an_instance_of Hash
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
