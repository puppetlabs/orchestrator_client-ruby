Gem::Specification.new do |s|
  s.name          = 'orchestrator_client'
  s.version       = '0.0.1'
  s.summary       = "Simple Ruby client library for PE Orchestration Services"
  s.authors       = "Puppet"
  s.email         = 'info@puppetlabs.com'
  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|scripts)/})
  end
  s.homepage      = 'https://github.com/puppetlabs/ruby-orchestrator_api'
  s.license       = "apache 2.0"
  s.require_paths = ["lib"]
end
