require File.expand_path("#{File.dirname(__FILE__)}/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

every :day, at: '0:05' do
  rake 'twitter_cron:search_tweets_everyday'
end
