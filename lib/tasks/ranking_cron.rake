namespace :ranking_cron do
  desc 'ツイート率の反映'
  task fetch_tweet_rate: :environment do
    RegisteredTag.all.each do |registered_tag|
      registered_tag.update!(tweet_rate: RegisteredTag.tweet_rate(registered_tag))
    end
  end
end
