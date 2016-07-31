if Rails.env.development?
  Sidekiq.configure_server do |config|
    config.redis = { host: "redis" }
  end

  Sidekiq.configure_client do |config|
    config.redis = { host: "redis" }
  end
end
