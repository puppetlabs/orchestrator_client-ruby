# Orchestrator_api

A simple client for interacting with the Orchestration Services API in Puppet Enterprise
[Puppet orchestration API](https://docs.puppet.com/pe/latest/api_index.html#puppet-orchestrator-api)

## Compatibility

Currently, this client supports the "V1" endpoints shipped as part of Puppet Enterprise 2016.2.

## Installation

```shell
gem install orchestrator_api
```

## Usage

Requires a token with 'Orchestration' permissions. By default the token is
expected to be at `~/.puppetlabs/token` which is the default location used by
`puppet-access` when creating token.

### initialization Settings

* `server` **[required]** - Hostname at which to reach the orchestrator service.
* `ca_certificate_file` **[required]** - Path to the CA certificate file needed to verify the SSL connection to the API.
* `port` - The port to reach the API on (defaults to "8143")
* `api_version` - Specify the version of the API to use (defaults to "v1")
* `token_path`- Path to a file with the RBAC token in it (defaults to `~/.puppetlabs/token`)
* `token` - Pass directly the RBAC token, if specified the token will be used instead of a token from file.

### Example

```ruby
require 'orchestrator_api'

# Create a new client
# Requires at least a server name and path to the CA certificate

client = Orchestrator_api.new({
                                :server              => "orchestrator.example.lan",
                                :ca_certificate_path => "/path/to/cert"
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

## Authors

Tom Linkin <tom@puppet.com>

## License

See LICENSE.
