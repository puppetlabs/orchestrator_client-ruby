#!/usr/bin/env ruby

require 'orchestrator_client'
require 'json'

conf_file = File.expand_path('~/.puppetlabs/client-tools/orchestrator.conf')
settings = File.open(conf_file) { |f| JSON.load(f) }

orch = OrchestratorClient.new(settings['options'])

options = {'scope' => {'query' => 'nodes {}'},
           'environment' => 'production',
          }

job = orch.new_job(options)

require 'pry'; binding.pry
