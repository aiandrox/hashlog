namespace :twitter_cron do
  desc 'TwitterAPIによる自動検索'
  task search_tweets_everyday: :environment do
    AddTweetsJob.perform_later
  end

  desc 'TwitterAPIによる自動ツイート'
  task remind_reply: :environment do
    RemindReplyJob.perform_later
  end
end
