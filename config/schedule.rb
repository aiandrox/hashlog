# herokuにしたので現在は使っていない

require File.expand_path("#{File.dirname(__FILE__)}/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

every 1.day, at: '5:30 am' do
  rake 'twitter_cron:fetch_user_data'
end

every 1.day, at: '6:00 am' do
  rake 'twitter_cron:add_tweets'
end

every 1.day, at: '7:00 am' do
  rake 'twitter_cron:remind_reply'
  rake 'ranking_cron:fetch_tweet_rate'
end
