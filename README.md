# ldap-client-rb

Ruby client interface for ActiveDirectory

## Installation

```shell
bundle install
```

## Run

Set the following environment variables:

* AD_SEARCH_USERNAME
* AD_SEARCH_PASSWORD
* AD_HOST
* AD_BASE (e.g. 'dc=example, dc=com,dc=br')
* AD_NAMESPACE (e.g. 'SAMPLE-COMPANY')

You can use a `.env` file for that

Run

```shell
bundle exec rackup
```

Access http://localhost:9292
