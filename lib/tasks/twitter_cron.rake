namespace :twitter_cron do
  desc 'ツイートを検索して保存'
  task search_tweets_everyday: :environment do
    logger = ActiveSupport::Logger.new(Rails.root.join('log/batch.log'))
    console = ActiveSupport::Logger.new(STDOUT) # この二行がないとlogger.infoが反映されない
    logger.extend ActiveSupport::Logger.broadcast(console)
    logger.level = Rails.logger.level # この二行でRails.loggerで出力したものを拾う
    Rails.logger = logger

    logger.info("\n#{DateTime.now}")
    registered_tags = RegisteredTag.all.includes(:user, :tag)
    registered_tags.each(&:add_tweets)
  end
end
