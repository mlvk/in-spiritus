[![Build Status](https://travis-ci.org/mlvk/in-spiritus.svg?branch=master)](https://travis-ci.org/mlvk/in-spiritus)
[![Code Climate](https://codeclimate.com/github/mlvk/in-spiritus/badges/gpa.svg)](https://codeclimate.com/github/mlvk/in-spiritus)
[![Test Coverage](https://codeclimate.com/github/mlvk/in-spiritus/badges/coverage.svg)](https://codeclimate.com/github/mlvk/in-spiritus/coverage)
[![Issue Count](https://codeclimate.com/github/mlvk/in-spiritus/badges/issue_count.svg)](https://codeclimate.com/github/mlvk/in-spiritus)
## In Spiritus
An attempt to simplify order and distribution management for startup food companies.

This project integrates with the following systems:

1. [Xero](https://www.xero.com)
1. [Routific](https://routific.com)
1. [Stripe](https://stripe.com/) - Future

### Vagrant Dev Environment Setup

1. Install [Vagrant](https://www.vagrantup.com/)
1. Clone the repo `git clone git@github.com:brancusi/in-spiritus.git`
1. Change dir to: `cd railsbox/development/`
1. Build and provision vagrant: `vagrant up`

### Working with the vagrant box

1. SSH into the box: `vagrant ssh`
1. Start rails: `rs` or long form: `rails server -b 0.0.0.0`
1. The server will now be accessible from your host machine on: [localhost:3000](http://localhost:3000)

### Start sidekiq

1. SSH into the box with a new shell: `vagrant ssh`
1. Start sidekiq: `sidekiq`

### Starting clockwork

1. SSH into the box: `vagrant ssh`
1. Start clockwork: `clockwork clock.rb`

### Vagrant box aliases

1. To move to the project directory: `app`
1. To start the rails server: `rs`
1. To connect to redis with redis-cli: `red`

### Setup
1. Run `rake secret` for each slot where needed in the secrets file
1. Install and start postgres
1. Run `db:reset`

## Misc
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
  1. __XERO_API_KEY__           : *required*
  1. __XERO_SECRET__            : *required*
  1. __XERO_PRIVATE_KEY__       : *required* `pbcopy < privatekey.pem`
  1. __REDIS_URL__              : *required*
  1. __SECRET_KEY_BASE__        : *required*
  1. __POSTGRESQL_DATABASE__    : *required*
  1. __POSTGRESQL_ADDRESS__     : *required*
  1. __POSTGRESQL_USERNAME__    : *required*
  1. __POSTGRESQL_PASSWORD__    : *required*
  1. __AWS_ACCESS_KEY_ID__      : *required*
  1. __AWS_SECRET_ACCESS_KEY__  : *required*
  1. __AWS_REGION__             : *required*
  1. __PDF_BUCKET__             : *required*
  1. __MAIL_GUN_API_KEY__       : *required*
  1. __MAIL_GUN_DOMAIN__        : *required*

### Start services
1. Start Redis: `redis-server /usr/local/etc/redis.conf`
1. Start Sidekiq: `bundle exec sidekiq`
1. Start Clockwork: `bundle exec clockwork clock.rb`
1. Start Rails: `rails s`

### Development
1. Start zeus: `zeus start`
1. Start guard: `bundle exec guard`

### Restore from local DB
1. pg_dump dbname > outfile
1. Log on the remote server
1. Turn down workers to stop sidekiq
1. `CD $STACK_PATH`
1. Drop db: `bundle exec rake db:drop`
1. Recreate db: `bundle exec rake db:create`
1. Get the dump file: `wget url`
1. Lookup the POSTGRESQL_USERNAME in cloud66
1. Restore `psql in_spiritus_staging < /home/az940/all.dump -U uesey3`

If there are problems with sticky connections try the following
1. Open the pg client: `psql -d postgres -U postgres`
1. Drop the connections to the target db
```SQL
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'db_name'
  AND pid <> pg_backend_pid();
```
1. Quit `\q`
1. Try to then drop with the above steps
