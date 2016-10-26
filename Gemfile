source 'https://rubygems.org'

gem 'rails', '4.2.7'
gem 'rake', '10.4.2'
gem 'devise'
gem 'pg', '0.18.4'
gem 'pundit'
gem 'rack-cors', :require => 'rack/cors'
gem 'jsonapi-resources', '0.8.0.beta1'
gem 'unirest'
gem 'monadic'
gem 'json', '~> 1.8.3'
gem 'okcomputer'
gem 'aasm'
gem 'xeroizer', :git => 'https://github.com/waynerobinson/xeroizer'
gem 'redis'
gem 'httplog'
gem 'aws-sdk'
gem 'firebase'
gem 'hamster'
gem 'globalid'
gem 'rest-client'

# Job scheduling
gem 'sidekiq'
gem 'sinatra', :require => nil
gem 'clockwork'
gem 'sidekiq-unique-jobs'

# Printing
gem 'prawn'
gem 'prawn-svg'

# Mail
gem 'mailgun-ruby', require: 'mailgun'

group :development do
  gem 'hirb'
  gem 'awesome_print'
  gem 'spring'
  gem 'rack-livereload'
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-minitest'
end

group :development, :staging, :test do
  gem 'dotenv-rails'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'gist'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-erd'
end

group :test do
  gem 'vcr'
  gem 'webmock', '~> 1.24.2'
  gem 'fakeredis'
  gem 'spy'
  gem 'codeclimate-test-reporter'
  gem 'maxitest'
  gem 'm', '~> 1.4.2'
end
