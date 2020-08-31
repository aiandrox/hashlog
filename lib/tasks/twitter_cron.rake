namespace :twitter_cron do
  desc 'TwitterAPIによる自動検索'
  task add_tweets: :environment do
    CronTwitter.new.call(TwitterAPIJob::AddTweets.new)
  end

  desc 'TwitterAPIによる自動ツイート'
  task remind_reply: :environment do
    CronTwitter.new.call(TwitterAPIJob::RemindReply.new)
  end
end
