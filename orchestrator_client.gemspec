lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'orchestrator_client/version'
Gem::Specification.new do |s|
  s.name          = 'orchestrator_client'
  s.version       = OrchestratorClient::VERSION
  s.summary       = "Simple Ruby client library for PE Orchestration Services"
  s.authors       = "Puppet"
  s.email         = 'info@puppetlabs.com'
  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|scripts)/})
  end
  s.homepage      = 'https://github.com/puppetlabs/orchestrator_client-ruby'
  s.license       = "Apache-2.0"
  s.require_paths = ["lib"]

  s.add_dependency 'faraday', '>= 1.4', '< 3.0'
  s.add_dependency 'faraday-net_http_persistent', '>= 1.0', '< 3.0'
end
