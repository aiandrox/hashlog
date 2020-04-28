class AddTweetsWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: 20

  sidekiq_retry_in do |count, exception|
    case exception
    when Twitter::Error::TooManyRequests
      930
    end
  end

  def perform
    logger.info("\n#{DateTime.now} : AddTweetsJob")
    registered_tags = RegisteredTag.all.includes(:user, :tag)
    registered_tags.each(&:add_tweets)
  rescue Twitter::Error::TooManyRequests => e
    logger.error('Twitter::Error::TooManyRequestsなので15分後に再試行します。')
    raise e
  end

  private

  attr_reader :logger

  def initialize
    set_logger
  end

  def set_logger
    @logger = ActiveSupport::Logger.new(Rails.root.join('log/batch.log'))
    console = ActiveSupport::Logger.new(STDOUT) # この二行がないとlogger.infoが反映されない
    @logger.extend ActiveSupport::Logger.broadcast(console)
    @logger.level = Rails.logger.level # この二行でRails.loggerで出力したものを拾う
    Rails.logger = @logger
  end
end
