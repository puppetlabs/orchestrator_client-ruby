#!/usr/bin/env ruby

require 'orchestrator_client'
require 'json'


orch = OrchestratorClient.new({}, true)

options = {'scope' => {'query' => 'nodes {}'},
           'environment' => 'production',
          }

job = orch.new_job(options)

require 'pry'; binding.pry
