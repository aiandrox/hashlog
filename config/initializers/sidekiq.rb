Sidekiq.configure_server do |config|
  config.redis = case Rails.env
                 when 'production' then
                   { url: 'redis://prd.redis-example.com:6379', namespace: 'sidekiq' }
                 when 'staging' then
                   { url: 'redis://stg.redis-example.com:6379', namespace: 'sidekiq' }
                 else
                   { url: 'redis://127.0.0.1:6379', namespace: 'sidekiq' }
                 end
end

Sidekiq.configure_client do |config|
  config.redis = case Rails.env
                 when 'production' then
                   config.redis = { url: 'redis://prd.redis-example.com:6379', namespace: 'sidekiq' }
                 when 'staging' then
                   config.redis = { url: 'redis://stg.redis-example.com:6379', namespace: 'sidekiq' }
                 else
                   config.redis = { url: 'redis://127.0.0.1:6379', namespace: 'sidekiq' }
                 end
end
