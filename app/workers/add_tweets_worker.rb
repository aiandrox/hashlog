class AddTweetsWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: 20

  def perform
    logger = ActiveSupport::Logger.new(Rails.root.join('log/batch.log'))
    console = ActiveSupport::Logger.new(STDOUT) # この二行がないとlogger.infoが反映されない
    logger.extend ActiveSupport::Logger.broadcast(console)
    logger.level = Rails.logger.level # この二行でRails.loggerで出力したものを拾う
    Rails.logger = logger

    logger.info("\n#{DateTime.now} : AddTweetsJob")
    registered_tags = RegisteredTag.all.includes(:user, :tag)
    registered_tags.each(&:add_tweets)
  end
end
