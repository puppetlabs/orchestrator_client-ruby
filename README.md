# OrchestratorClient

A simple client for interacting with the Orchestration Services API in Puppet Enterprise
[Puppet orchestration API](https://docs.puppet.com/pe/latest/api_index.html#puppet-orchestrator-api)

## Compatibility

Currently, this client supports the "V1" endpoints shipped as part of Puppet Enterprise 2016.2 -
2019.8.4.

## Installation

```shell
gem install orchestrator_client
```

## Usage

Requires a token with 'Orchestration' permissions. By default the token is
expected to be at `~/.puppetlabs/token` which is the default location used by
`puppet-access` when creating token.

### initialization Settings

* `service-url` **[required]** - Base URL for the location of the Orchestrator API service
* `cacert` **[required]** - Path to the CA certificate file needed to verify the SSL connection to the API.
* `token-file`- Path to a file with the RBAC token in it (defaults to `~/.puppetlabs/token`)
* `token` - Pass directly the RBAC token, if specified the token will be used instead of a token from file.
* `User-Agent`- Set `User-Agent` header for HTTP requests. Defaults to `OrchestratorRubyClient/[VERSION]`
* `job-poll-interval`- Set the default amount of time to sleep when polling in Orchestrator::Job#wait and #each\_event
* `job-poll-timeout`- Set the default maximum amount of time to wait in Orchestrator::Job#wait
* `read-timeout` - The time to wait before raising a Timeout exception when making HTTP requests.

### Example

```ruby
require 'orchestrator_client'

# Create a new client
# Requires at least a server name and path to the CA certificate

client = OrchestratorClient.new({
                                'service-url' => 'https://orchestrator.example.lan:8143/orchestrator/v1',
                                'cacert'     => '/path/to/cert'
                              })

## Access endpoints through the client object

# Get details on all known jobs
result = client.jobs.all

# Get details on Individual jobs (job "5" in this example)
client.jobs.details(5)

# Perform an orchestrator deployment
new_job_details = client.command.deploy('production', {'noop' => true })
```

## Tests

```shell
bundle install
bundle exec rspec
```

## Issues & Contributions

File issues or feature requests using [GitHub
issues](https://github.com/puppetlabs/orchestrator_api-ruby/issues).

If you are interested in contributing to this project, please see the
[Contribution Guidelines](CONTRIBUTING.md)

## Releasing

Use the
https://cinext-jenkinsmaster-sre-prod-1.delivery.puppetlabs.net/job/qe_orchestrator-client-ruby_init-multijob_master/
job to release. This pipeline will update the [version file](lib/orchestrator_client/version.rb),
create the tag you specify, and push release [to
rubygems](https://rubygems.org/gems/orchestrator_client).

## License

See LICENSE.
