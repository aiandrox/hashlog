namespace :twitter_cron do
  desc 'Twitterアカウントプロフィールの反映'
  task fetch_user_data: :environment do
    CronTwitter.new.call(Job::UpdateUserTwitterData.new)
  end

  desc 'TwitterAPIによる自動検索'
  task add_tweets: :environment do
    registered_tags = RegisteredTag.joins(:user, :tag).merge(User.not_deleted)
    CronTwitter.new.call(Job::AddTweets.new(registered_tags))
  end

  desc 'TwitterAPIによる自動ツイート'
  task remind_reply: :environment do
    CronTwitter.new.call(Job::RemindReply.new)
  end
end
