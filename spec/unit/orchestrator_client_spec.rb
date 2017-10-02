require 'spec_helper'

describe OrchestratorClient do

  before(:each) do

    @config = {
      'service-url' => 'https://orchestrator.example.lan:8143',
      'cacert' => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
      'token' => 'myfaketoken'
    }
    @orchestrator_api = OrchestratorClient.new(@config)
  end

  describe "#newobject" do
    it "takes a configuration hash and returns a OrchestratorClient object" do
      expect(@orchestrator_api).to be_an_instance_of OrchestratorClient
    end


    it "has methods with objects that are not nil" do
      expect(@orchestrator_api.command).to be_truthy
      expect(@orchestrator_api.jobs).to be_truthy
    end

    it "complains when a configuration value for 'service-url' is not provided" do
      @config.delete('service-url')
      expect{ OrchestratorClient.new(@config) }.to raise_error("'service-url' is required in config")
    end

    it "complains when a configuration value for 'cacert' is not provided" do
      @config.delete('cacert')
      expect{ OrchestratorClient.new({'cacert' => nil, 'service-url' => 'https://example.com'}) }.to raise_error("'cacert' is required in config")
    end
  end

  describe "#get" do
    it 'takes an endpoint and parses the response as JSON' do
      stub_request(:get, "https://orchestrator.example.lan:8143/orchestrator/v1/endpoint").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 200, :body => "{}", :headers => {})

      expect(@orchestrator_api.get('endpoint')).to be_an_instance_of Hash
    end
  end

  describe "#post" do
    it 'takes an endpoint, endpoint, and parses the response as JSON' do
      stub_request(:post, "https://orchestrator.example.lan:8143/orchestrator/v1/endpoint").
        with( :body => "{\"data\":\"atad\"}",
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby', 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 202, :body => "{}", :headers => {})

      expect(@orchestrator_api.post('endpoint',{'data' => 'atad'})).to be_an_instance_of Hash
    end
  end
end
