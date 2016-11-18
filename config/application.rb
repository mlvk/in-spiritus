require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :itemion.
Bundler.require(*Rails.groups)

module InSpiritus
  class Application < Rails::Application

    config.middleware.use Rack::Deflater

    config.middleware.insert_before 0, "Rack::Cors", :debug => true, :logger => (-> { Rails.logger }) do
      allow do
        origins '*'

        resource '/cors',
          :headers => :any,
          :methods => [:post],
          :credentials => true,
          :max_age => 0

        resource '*',
          :headers => :any,
          :methods => [:get, :post, :delete, :put, :patch, :options, :head],
          :max_age => 0
      end
    end

    config.assets.enabled = true
    config.serve_static_files = true

    config.generators do |g|
      g.factory_girl false
    end

    config.time_zone = 'Pacific Time (US & Canada)'
    Time.zone = "Pacific Time (US & Canada)"
  end
end
