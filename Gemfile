source 'https://rubygems.org'

gem 'rails', '4.2.8'
gem 'rake'
gem 'devise'
gem 'pg', '0.18.4'
gem 'pundit'
gem 'rack-cors', :require => 'rack/cors'
gem 'jsonapi-resources', '0.8.1'
gem 'monadic'
gem 'json', '~> 1.8.3'
gem 'okcomputer'
gem 'aasm'
gem 'xeroizer', :git => 'https://github.com/waynerobinson/xeroizer'
gem 'redis', '3.3.1'
gem 'aws-sdk'
gem 'firebase'
gem 'hamster'
gem 'globalid'
gem 'rest-client'
gem 'google-api-client', '~> 0.9'

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
  gem 'spring'
  gem 'rack-livereload'
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-minitest'
  gem 'httplog'
end

group :development, :staging, :test do
  gem 'zeus'
  gem 'dotenv-rails'
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'gist'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-erd'
  gem 'hirb'
  gem 'awesome_print'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'fakeredis'
  gem 'spy'
  gem 'maxitest'
end
