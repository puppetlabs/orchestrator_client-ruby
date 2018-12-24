require 'spec_helper'

describe OrchestratorClient do

  let(:config) do
    {
      'service-url' => 'https://orchestrator.example.lan:8143',
      'cacert' => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
      'token' => 'myfaketoken'
    }
  end
  let(:orchestrator) { OrchestratorClient.new(config) }
  let(:job_options) { {} }
  let(:job) { orchestrator.new_job(job_options) }

  describe "#newobject" do
    it "takes a configuration hash and returns a OrchestratorClient::Job object" do
      expect(job).to be_an_instance_of OrchestratorClient::Job
    end

    it "correctly defaults job-poll-interval" do
      expect(job.instance_variable_get(:@poll_interval)).to eq(1)
    end

    it "correctly defaults job-poll-timeout" do
      expect(job.instance_variable_get(:@poll_timeout)).to eq(1000)
    end

    context "with job-poll-interval and job-poll-timeout specified in config" do
      let(:config) { super().merge('job-poll-interval' => 0.1, 'job-poll-timeout' => 500) }

      it "sets job-poll-interval from config" do
        expect(job.instance_variable_get(:@poll_interval)).to eq(0.1)
      end

      it "sets job-poll-timeout from config" do
        expect(job.instance_variable_get(:@poll_timeout)).to eq(500)
      end
    end

    context "with _poll_interval and _poll_timeout set as job options" do
      let(:job_options) { { _poll_interval: 0.5, _poll_timeout: 100 } }

      it "sets job-poll-interval from job options" do
        expect(job.instance_variable_get(:@poll_interval)).to eq(0.5)
      end

      it "sets job-poll-timeout from job options" do
        expect(job.instance_variable_get(:@poll_timeout)).to eq(100)
      end
    end
  end

  describe "#wait" do
    let(:config) { super().merge('job-poll-timeout' => 100, 'job-poll-interval' => 2) }

    before(:each) do
      allow(job).to receive(:get_details).and_return(nil)
      allow(job).to receive(:details).and_return({})
    end

    it 'waits for 2 seconds 50 times before timing out' do
      expect(job).to receive(:sleep).with(2).exactly(50).times
      job.wait
    end
  end
end
