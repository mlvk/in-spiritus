[![Build Status](https://travis-ci.org/mlvk/in-spiritus.svg?branch=master)](https://travis-ci.org/mlvk/in-spiritus)
[![Code Climate](https://codeclimate.com/github/mlvk/in-spiritus/badges/gpa.svg)](https://codeclimate.com/github/mlvk/in-spiritus)
[![Test Coverage](https://codeclimate.com/github/mlvk/in-spiritus/badges/coverage.svg)](https://codeclimate.com/github/mlvk/in-spiritus/coverage)
[![Issue Count](https://codeclimate.com/github/mlvk/in-spiritus/badges/issue_count.svg)](https://codeclimate.com/github/mlvk/in-spiritus)
## In Spiritus
To simplify order and distribution management for startup food companies.

This project integrates with the following systems:

1. [Xero](https://www.xero.com)
1. [Routific](https://routific.com)

### Setup Dev Environment
1. Run `rake secret` for each slot where needed in the secrets file
1. Install docker on your system

### Setup Third Party Services
1. Signup for Xero
1. Signup for mailgun
1. Signup for AWS
1. Signup for papertrail

### Setup papertrail logging
1. Signup for [papertrail](https://papertrailapp.com)
1. Create a new log [destination](https://papertrailapp.com/account/destinations)
1. Duplicate and rename `config/log_config.example.yml` ~> `config/log_config.yml`
1. Copy the Host and Port into `config/log_config.yml`

### Setup Xero
1. Generate keys:
  ```bash
  openssl genrsa -out privatekey.pem 1024
  openssl req -new -x509 -key privatekey.pem -out publickey.cer -days 1825
  openssl pkcs12 -export -out public_privatekey.pfx -inkey privatekey.pem -in publickey.cer
  ```
1. `pbcopy < publickey.cer` - Copy the public key to your clipboard
1. Create a `demo company` via the xero interface [Create demo account](https://my.xero.com/!xkcD/Dashboard)
1. Goto the xero dev console [Xero Dev - Applications](https://app.xero.com/Application/List)
1. Create a new private application.
1. Select the demo account
1. Paste in the public key copied from the earlier step

### Setup ENV vars
Add in the following env vars to the stack
1. __XERO_API_KEY__           : *required* `Consumer Key`
1. __XERO_SECRET__            : *required* `Consumer Secret`
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

**Note** The private key needs to be converted to a single line with newlines replaced with `\n`
Example: `"-----BEGIN RSA PRIVATE KEY-----\nMIICXAIBAAKBgQC7yxBqf5NnEFeyNkNIj+1EIFK4NDsOSITYkNh7kQSKbyUmHes1\nAE29ePg7+S8mYhMBfQy0U/2IGI9RDsQKsZLpEj0iiBpBLtl0N1sg90Nc+RjEAPaR\nA63bKVDi1fCstilaQbXN7dQeGEOg83Zh/5WzNtdJlC823iDoWwCWVhK63wIDAQAB\nAoGARZCKazkJDHO0WLLbJ8URGlxy6AOJINhiRasaVmO47+MOOpl2Xx9RrLPkvKtM\n+QX5jmKZUu+NsqhOZrN2kZOIHKS7lV/+6HkxCVhmkWFN1Y0oapaZ8Gggp7OJ2uwP\nv3eXeOzZnlqY/cwjDzntgyO5Gyek47rwh319q62VRxwJ/wECQQD5LRCRfQryrYgu\nVO2wjOeWX3bfHI8wk+8wjwQ7BSdROME2N+/opUuWUZ5pmjaowEYuSuEqdakkDIfU\n1EseYwFfAkEAwO+nYRrMIW9Jv7zWB0sHK3f01rQqL0uRudRkZoaMKRu+CzODOdHX\n3PMqgPlip9OypK/uDRL1teQ8zj+QDTs2gQJBALOmxSJQSFttuBjHjNPU04g8bhRU\nnvyEPFkDVCaFcbKCu/MuY1+WBahsU22LLUt/zVnFDRDC4l8mVayiH0LaWPsCQH2i\nkWgWPx71jruiJ+0P2ldgAbteDqpFl1tfBxIMQ3Dxc8tve+BG2T4zylW6D5ghro63\nUViKJB6RxVa45WD4UgECQFWqHSe84+hoNgel5gZw2nIF8kNvnT0mI6EQRTfXqFcG\nXlR1tb04Ega6LrgXD7W120NXPKK+R3GO2AxIi7vg9qU=\n-----END RSA PRIVATE KEY-----"`

### Install the [in-spiritus-cli](https://github.com/mlvk/in-spiritus-cli) tool
1. `npm install -g mlvk/in-spiritus-cli`
1. `is serve` - Starts the services

## Manage the containers with docker-compose
### Starting containers
1. `docker-compose up` - To start just to base services (without workers)
1. `docker-compose -f docker-compose-all.yml up` - To start all services

### Exec against running containers
1. `docker-compose exec web rake db:reset` - Run the first time you build the containers

### Util Commands
1. `docker-compose exec web rake db:migrate` - To run migrations
1. `docker-compose exec web rake erd` - Generate Entity-Relationship Diagrams
1. `docker-compose exec web rails c` - Start a rails console
1. `docker-compose exec web bash` - Start a bash shell on the web container
1. `docker-compose exec db psql -U postgres` - Open a psql command line in the db container
1. `docker-compose exec redis redis-cli` - Start the redis-cli on the redis container

### Domain Model Diagram
![alt tag](https://github.com/brancusi/in-spiritus/blob/master/erd.png)
