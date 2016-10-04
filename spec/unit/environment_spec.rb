require 'spec_helper'

describe Orchestrator_api::Environments do

  before :each do
    config = {
      'service-url' => 'https://orchestrator.example.lan:8143/orchestrator/v1',
      'ca_cert'     => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
      'token'       => 'myfaketoken'
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
