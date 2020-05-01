namespace :twitter_cron do
  desc 'ツイートを検索して保存'
  task search_tweets_everyday: :environment do
    AddTweetsJob.perform_later
  end
end
