namespace :twitter_cron do
  desc 'ツイートを検索して保存'
  task search_tweets_everyday: :environment do
    registered_tags = RegisteredTag.all.includes(:user, :tag)
    registered_tags.each do |registered_tag|
      registered_tag.add_tweets
    end
  end
end
