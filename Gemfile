source 'https://rubygems.org'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.3.1'

gem 'rails', '~> 5.2.0'
gem 'rake'
gem 'devise'
gem 'pg'
gem 'pundit'
gem 'rack-cors', :require => 'rack/cors'
gem 'jsonapi-resources', '0.8.1'
gem 'monadic'
gem 'json'
gem 'okcomputer'
gem 'aasm'
gem 'xeroizer'
gem 'redis'
gem 'aws-sdk'
gem 'firebase'
gem 'hamster'
gem 'globalid'
gem 'rest-client'
gem 'google-api-client'

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

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

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
  gem "factory_bot_rails"
  gem 'faker'
  gem 'gist'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-erd'
  gem 'hirb'
  gem 'awesome_print'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'fakeredis'
  gem 'spy'
  gem 'maxitest'

  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end
