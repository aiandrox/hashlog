class AddTweetsWorker
  include LoggerHelper
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
end
