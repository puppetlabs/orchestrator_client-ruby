require 'spec_helper'

describe OrchestratorClient::Jobs do

  before :each do
    cert_path = File.join(File.expand_path(File.dirname(__FILE__)), '../fixtures/ca.pem')
    @config = {
      'service-url' => 'https://orchestrator.example.lan:8143',
      'cacert' => cert_path,
      'token' => 'myfaketoken'
    }

    @orchestrator = OrchestratorClient.new(@config)
  end

  describe '#newobject' do
    it 'takes an orchestrator url and OrchestratorClient object and returns a OrchestratorClient::Jobs object' do
      expect(@orchestrator.jobs).to be_an_instance_of OrchestratorClient::Jobs
    end
  end

  describe '#all' do
    response =  "{\n  \"items\" : [ {\n    \"report\" : {\n      \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/58/report\"\n    },\n    \"name\" : \"58\",\n    \"events\" : {\n      \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/58/events\"\n    },\n    \"state\" : \"failed\",\n    \"nodes\" : {\n      \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/58/nodes\"\n    },\n    \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/58\",\n    \"environment\" : {\n      \"name\" : \"production\"\n    },\n    \"options\" : {\n      \"concurrency\" : null,\n      \"noop\" : false,\n      \"trace\" : false,\n      \"debug\" : false,\n      \"scope\" : {\n        \"whole_environment\" : true\n      },\n      \"enforce_environment\" : true,\n      \"environment\" : \"production\",\n      \"evaltrace\" : false,\n      \"target\" : \"whole environment\"\n    },\n    \"timestamp\" : \"2016-09-20T19:01:18Z\",\n    \"owner\" : {\n      \"id\" : \"80f8475c-d8b5-4dfd-b567-3cae4ef7a3a7\",\n      \"login\" : \"tom\"\n    },\n    \"node_count\" : 2\n  } ]\n}"

    it 'optionally accepts a number to limit results' do
      stub_request(:get, "https://orchestrator.example.lan:8143/orchestrator/v1/jobs?limit=1").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>"OrchestratorRubyClient/#{OrchestratorClient::VERSION}", 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 200, :body => response, :headers => {})

      expect(@orchestrator.jobs.all(1)).to be_an_instance_of Hash
    end

    it 'can return results without a limit' do
      response =  "{\n  \"items\" : [ {\n    \"report\" : {\n      \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/58/report\"\n    },\n    \"name\" : \"58\",\n    \"events\" : {\n      \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/58/events\"\n    },\n    \"state\" : \"failed\",\n    \"nodes\" : {\n      \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/58/nodes\"\n    },\n    \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/58\",\n    \"environment\" : {\n      \"name\" : \"production\"\n    },\n    \"options\" : {\n      \"concurrency\" : null,\n      \"noop\" : false,\n      \"trace\" : false,\n      \"debug\" : false,\n      \"scope\" : {\n        \"whole_environment\" : true\n      },\n      \"enforce_environment\" : true,\n      \"environment\" : \"production\",\n      \"evaltrace\" : false,\n      \"target\" : \"whole environment\"\n    },\n    \"timestamp\" : \"2016-09-20T19:01:18Z\",\n    \"owner\" : {\n      \"id\" : \"80f8475c-d8b5-4dfd-b567-3cae4ef7a3a7\",\n      \"login\" : \"tom\"\n    },\n    \"node_count\" : 2\n  } ]\n}"

      stub_request(:get, "https://orchestrator.example.lan:8143/orchestrator/v1/jobs").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>"OrchestratorRubyClient/#{OrchestratorClient::VERSION}", 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 200, :body => response, :headers => {})

      expect(@orchestrator.jobs.all).to be_an_instance_of Hash
    end
  end

  describe '#details' do
  end

  describe '#nodes' do
  end

  describe '#report' do
  end

  describe '#events' do
    response = "{\n  \"next-events\" : {\n    \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/1/events?start=7\"\n  },\n  \"items\" : [ {\n    \"type\" : \"node_finished\",\n    \"timestamp\" : \"2016-08-15T21:35:26Z\",\n    \"details\" : {\n      \"node\" : \"orchestrator.example.lan\",\n      \"detail\" : {\n        \"hash\" : \"c02e060e07da2a0e3ecdbad0e46a265ca22f433d\",\n        \"noop\" : false,\n        \"status\" : \"unchanged\",\n        \"metrics\" : {\n          \"corrective_change\" : 0,\n          \"out_of_sync\" : 3,\n          \"restarted\" : 0,\n          \"skipped\" : 0,\n          \"total\" : 789,\n          \"changed\" : 0,\n          \"scheduled\" : 0,\n          \"failed_to_restart\" : 0,\n          \"failed\" : 0\n        },\n        \"report-url\" : \"https://orchestrator.example.lan/#/cm/report/c02e060e07da2a0e3ecdbad0e46a265ca22f433d\",\n        \"environment\" : \"production\",\n        \"configuration_version\" : \"1471296883\"\n      }\n    },\n    \"message\" : \"Finished puppet run on orchestrator.example.lan - Success! \",\n    \"id\" : \"6\"\n  } ]\n}"

    it 'takes a job number and accespts a start number to retrieve latest results' do
      stub_request(:get, "https://orchestrator.example.lan:8143/orchestrator/v1/jobs/1/events?start=10").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>"OrchestratorRubyClient/#{OrchestratorClient::VERSION}", 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 200, :body => response, :headers => {})

      expect(@orchestrator.jobs.events(1,10)).to be_an_instance_of Hash
    end
    it 'takes a job number but does not need a start number' do
      response = "{\n  \"next-events\" : {\n    \"id\" : \"https://orchestrator.example.lan:8143/orchestrator/v1/jobs/1/events?start=7\"\n  },\n  \"items\" : [ {\n    \"type\" : \"node_running\",\n    \"timestamp\" : \"2016-08-15T21:34:34Z\",\n    \"details\" : {\n      \"node\" : \"orchestrator.example.lan\",\n      \"detail\" : {\n        \"noop\" : false\n      }\n    },\n    \"message\" : \"Started puppet run on orchestrator.example.lan ...\",\n    \"id\" : \"1\"\n  }, {\n    \"type\" : \"node_running\",\n    \"timestamp\" : \"2016-08-15T21:34:34Z\",\n    \"details\" : {\n      \"node\" : \"agent2.puppetlabs.vm\",\n      \"detail\" : {\n        \"noop\" : false\n      }\n    },\n    \"message\" : \"Started puppet run on agent2.puppetlabs.vm ...\",\n    \"id\" : \"2\"\n  }, {\n    \"type\" : \"node_running\",\n    \"timestamp\" : \"2016-08-15T21:34:34Z\",\n    \"details\" : {\n      \"node\" : \"agent1.puppetlabs.vm\",\n      \"detail\" : {\n        \"noop\" : false\n      }\n    },\n    \"message\" : \"Started puppet run on agent1.puppetlabs.vm ...\",\n    \"id\" : \"3\"\n  }, {\n    \"type\" : \"node_finished\",\n    \"timestamp\" : \"2016-08-15T21:34:47Z\",\n    \"details\" : {\n      \"node\" : \"agent1.puppetlabs.vm\",\n      \"detail\" : {\n        \"hash\" : \"20d60265af8bafc0ac1b99c1eb4b8bde411a81a3\",\n        \"noop\" : false,\n        \"status\" : \"unchanged\",\n        \"metrics\" : {\n          \"corrective_change\" : 0,\n          \"out_of_sync\" : 0,\n          \"restarted\" : 0,\n          \"skipped\" : 0,\n          \"total\" : 171,\n          \"changed\" : 0,\n          \"scheduled\" : 0,\n          \"failed_to_restart\" : 0,\n          \"failed\" : 0\n        },\n        \"report-url\" : \"https://orchestrator.example.lan/#/cm/report/20d60265af8bafc0ac1b99c1eb4b8bde411a81a3\",\n        \"environment\" : \"production\",\n        \"configuration_version\" : \"1471296882\"\n      }\n    },\n    \"message\" : \"Finished puppet run on agent1.puppetlabs.vm - Success! \",\n    \"id\" : \"4\"\n  }, {\n    \"type\" : \"node_finished\",\n    \"timestamp\" : \"2016-08-15T21:34:47Z\",\n    \"details\" : {\n      \"node\" : \"agent2.puppetlabs.vm\",\n      \"detail\" : {\n        \"hash\" : \"d460f0a513b1e18d43f19867b269cf105772fc41\",\n        \"noop\" : false,\n        \"status\" : \"unchanged\",\n        \"metrics\" : {\n          \"corrective_change\" : 0,\n          \"out_of_sync\" : 0,\n          \"restarted\" : 0,\n          \"skipped\" : 0,\n          \"total\" : 171,\n          \"changed\" : 0,\n          \"scheduled\" : 0,\n          \"failed_to_restart\" : 0,\n          \"failed\" : 0\n        },\n        \"report-url\" : \"https://orchestrator.example.lan/#/cm/report/d460f0a513b1e18d43f19867b269cf105772fc41\",\n        \"environment\" : \"production\",\n        \"configuration_version\" : \"1471296882\"\n      }\n    },\n    \"message\" : \"Finished puppet run on agent2.puppetlabs.vm - Success! \",\n    \"id\" : \"5\"\n  }, {\n    \"type\" : \"node_finished\",\n    \"timestamp\" : \"2016-08-15T21:35:26Z\",\n    \"details\" : {\n      \"node\" : \"orchestrator.example.lan\",\n      \"detail\" : {\n        \"hash\" : \"c02e060e07da2a0e3ecdbad0e46a265ca22f433d\",\n        \"noop\" : false,\n        \"status\" : \"unchanged\",\n        \"metrics\" : {\n          \"corrective_change\" : 0,\n          \"out_of_sync\" : 3,\n          \"restarted\" : 0,\n          \"skipped\" : 0,\n          \"total\" : 789,\n          \"changed\" : 0,\n          \"scheduled\" : 0,\n          \"failed_to_restart\" : 0,\n          \"failed\" : 0\n        },\n        \"report-url\" : \"https://orchestrator.example.lan/#/cm/report/c02e060e07da2a0e3ecdbad0e46a265ca22f433d\",\n        \"environment\" : \"production\",\n        \"configuration_version\" : \"1471296883\"\n      }\n    },\n    \"message\" : \"Finished puppet run on orchestrator.example.lan - Success! \",\n    \"id\" : \"6\"\n  } ]\n}"

      stub_request(:get, "https://orchestrator.example.lan:8143/orchestrator/v1/jobs/1/events").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>"OrchestratorRubyClient/#{OrchestratorClient::VERSION}", 'X-Authentication'=>'myfaketoken'}).
        to_return(:status => 200, :body => response, :headers => {})

      expect(@orchestrator.jobs.events(1)).to be_an_instance_of Hash
    end
  end
end

