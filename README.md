[![Build Status](https://travis-ci.org/brancusi/in-spiritus.svg?branch=master)](https://travis-ci.org/brancusi/in-spiritus)
[![Code Climate](https://codeclimate.com/github/brancusi/in-spiritus/badges/gpa.svg)](https://codeclimate.com/github/brancusi/in-spiritus)
[![Test Coverage](https://codeclimate.com/github/brancusi/in-spiritus/badges/coverage.svg)](https://codeclimate.com/github/brancusi/in-spiritus/coverage)
[![Issue Count](https://codeclimate.com/github/brancusi/in-spiritus/badges/issue_count.svg)](https://codeclimate.com/github/brancusi/in-spiritus)
## In Spiritus
An attempt to simplify order and distribution management for startup food companies.

This project integrates with the following systems:

1. [Xero](https://www.xero.com)
1. [Routific](https://routific.com)
1. [Stripe](https://stripe.com/) - Future

### Setup
1. Run `rake secret` for each slot where needed in the secrets file
1. Install and start postgres
1. Run `db:reset`

## Development
1. Generate new domain model uml: `rake erd`
1. Tidy schema: `rake db:schema:dump`

### Domain Model Diagram
![alt tag](https://github.com/brancusi/in-spiritus/blob/master/erd.png)

### Setup Xero
1. Generate keys:

    ```bash
    openssl genrsa -out privatekey.pem 1024
    openssl req -new -x509 -key privatekey.pem -out publickey.cer -days 1825
    openssl pkcs12 -export -out public_privatekey.pfx -inkey privatekey.pem -in publickey.cer
    pbcopy < publickey.cer
    ```
1. Create a demo account via the xero interface [Create demo account](https://my.xero.com/!xkcD/Dashboard)
1. Goto the xero dev console [Xero Dev - Applications](https://app.xero.com/Application/List)
1. Create a new private application.
1. Select the demo account
1. Paste in the public key
1. Add in the following env vars to the stack
  1. __XERO_API_KEY__ : *required*
  1. __XERO_SECRET__ : *required*
  1. __XERO_PRIVATE_KEY__ : *required* `pbcopy < privatekey.pem`
  1. __REDIS_URL__ : *required*
  1. __SECRET_KEY_BASE__ : *required*
  1. __POSTGRESQL_DATABASE__ : *required*
  1. __POSTGRESQL_ADDRESS__ : *required*
  1. __POSTGRESQL_USERNAME__ : *required*
  1. __POSTGRESQL_PASSWORD__ : *required*

### Start services
1. Start Redis: `redis-server /usr/local/etc/redis.conf`
1. Start Clockwork: `bundle exec clockwork clock.rb`
1. Start Sidekiq: `bundle exec sidekiq`
1. Start Rails: `rails s`
