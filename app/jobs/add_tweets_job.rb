class AddTweetsJob < ApplicationJob
  queue_as :default

  rescue_from Twitter::Error::TooManyRequests do
    logger.error('Twitter::Error::TooManyRequestsなので15分後に再試行します。')
    retry_job wait: 15.minutes, queue: :low_priority
  end

  def perform
    logger.info("\n#{DateTime.now} : AddTweetsJob")
    registered_tags = RegisteredTag.all.includes(:user, :tag)
    registered_tags.each(&:add_tweets)
  end
end
