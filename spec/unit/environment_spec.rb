require 'spec_helper'

describe Orchestrator_api::Environments do

  before :each do
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
    it 'takes an orchestrator url and Orchestrator_api object and returns a Orchestrator_api::Environment object' do
      expect(@orchestrator.environments).to be_an_instance_of Orchestrator_api::Environments
    end
  end

  describe '#all' do
  end

  describe '#applications' do
  end

  describe '#instances' do
  end
end
