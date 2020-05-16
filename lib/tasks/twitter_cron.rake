namespace :twitter_cron do
  desc 'TwitterAPIによる自動検索'
  task search_tweets_everyday: :environment do
    AddTweetsJob.perform_later
  end

  desc 'TwitterAPIによる自動ツイート'
  task remind_tweet: :environment do
    RemindTweetJob.perform_later
  end
end
