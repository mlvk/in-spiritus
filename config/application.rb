require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :itemion.
Bundler.require(*Rails.groups)

module InSpiritus
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.middleware.use Rack::Deflater

    config.middleware.insert_before 0, Rack::Cors, :debug => true, :logger => (-> { Rails.logger }) do
      allow do
        origins /\Ahttp:\/\/localhost(:\d+)?\z/, /\Ahttps?:\/\/(.+?\.)?mlvk\.org\z/

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
    config.public_file_server.enabled = true

    config.autoload_paths << "#{Rails.root}/app/resources/concerns"

    config.generators do |g|
      g.factory_bot false
    end

    config.time_zone = 'Pacific Time (US & Canada)'
    Time.zone = "Pacific Time (US & Canada)"
  end
end
