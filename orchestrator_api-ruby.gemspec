Gem::Specification.new do |s|
  s.name          = 'orchestrator_api'
  s.version       = '0.0.2'
  s.summary       = "Simple Ruby client library for PE Orchestration Services"
  s.authors       = "Thomas Linkin"
  s.email         = 'info@puppet.com'
  s.files         = `git ls-files`.split($/)
  s.homepage      = 'https://github.com/puppetlabs/orchestrator_api-ruby'
  s.license       = "apache"
  s.require_paths = ["lib"]
end
