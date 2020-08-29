namespace :twitter_cron do
  desc 'TwitterAPIによる自動検索'
  task add_tweets: :environment do
    CronTwitter.new(:add_tweets).call
  end

  desc 'TwitterAPIによる自動ツイート'
  task remind_reply: :environment do
    CronTwitter.new(:remind_reply).call
  end
end
