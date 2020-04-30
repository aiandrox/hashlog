Sidekiq.configure_server do |config|
  config.redis = { url: Settings[:sidekiq][:url], namespace: 'sidekiq' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Settings[:sidekiq][:url], namespace: 'sidekiq' }
end
