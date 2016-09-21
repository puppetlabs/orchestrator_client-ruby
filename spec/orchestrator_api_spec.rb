require 'spec_helper'
require_relative '../lib/orchestrator_api'

describe Orchestrator_api do

  before(:all) do
    config = {
      'server'              => 'orchestrator.example.lan',
      'ca_certificate_path' => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
      'port'                => '8143',
      'api_version'         => 'v1',
      'token'               => 'myfaketoken'
    }

    @orchestrator_api = Orchestrator_api.new(config)
  end

  describe "#newobject" do
    it "takes a configuration hash and returns a Orchestrator_api object" do
      expect(@orchestrator_api).to be_an_instance_of Orchestrator_api
    end


    it "has methods with objects that are not nil" do
      expect(@orchestrator_api.command).to be_truthy
      expect(@orchestrator_api.jobs).to be_truthy
      expect(@orchestrator_api.environments).to be_truthy
    end

    it "complains when a configuration value for 'server' is not provided" do
      config = {
        'ca_certificate_path' => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
        'port'                => '8143',
        'api_version'         => 'v1',
        'token'               => 'myfaketoken'
      }

      expect{ Orchestrator_api.new(config) }.to raise_error("Configuration error: 'server' must specify the server running the Orchestration services and cannot be empty")
    end

    it "complains when a configuration value for 'ca_certificate_path' is not provided" do
      config = {
        'server'              => 'orchestrator.example.lan',
        'port'                => '8143',
        'api_version'         => 'v1',
        'token'               => 'myfaketoken'
      }

      expect{ Orchestrator_api.new(config) }.to raise_error("Configuration error: 'ca_certificate_path' must specify a path to the CA certificate used for communications with the server and cannot be empty")
    end
  end

  describe "#get" do
    it 'takes an endpoint and parses the response as JSON' do
      stub_request(:get, "https://orchestrator.example.lan:8143/endpoint").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 200, :body => "{}", :headers => {})

      expect(@orchestrator_api.get('/endpoint')).to be_an_instance_of Hash
    end
  end

  describe "#post" do
    it 'takes an endpoint, endpoint, and parses the response as JSON' do
      stub_request(:post, "https://orchestrator.example.lan:8143/endpoint").
        with( :body => "{\"data\":\"atad\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 202, :body => "{}", :headers => {})

      expect(@orchestrator_api.post('/endpoint',{'data' => 'atad'})).to be_an_instance_of Hash
    end
  end
end
