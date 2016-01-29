source 'https://rubygems.org'

gem 'rails', '4.2.5'
gem 'rake', '10.4.2'
gem 'devise'
gem 'pg', '0.18.4'
gem 'pundit'
gem 'rack-cors', :require => 'rack/cors'
gem 'jsonapi-resources'
gem 'unirest'
gem 'monadic'
gem 'json', '~> 1.8.3'
gem 'okcomputer'

group :production do
  gem 'unicorn'
  gem 'unicorn-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_21]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'hirb'
  gem 'awesome_print'
  gem 'interactive_editor'
  gem 'rack-mini-profiler'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'spring'
end
group :development, :test do
  gem 'dotenv-rails'
  gem 'gist'
end
group :test do
  gem 'database_cleaner'
end
