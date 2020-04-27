class AddTweetsJob < ApplicationJob
  queue_as :default
  rescue_from Twitter::Error::TooManyRequests do |e|
    time = e.rate_limit.reset_in + 10
    set(wait_until: time.seconds.since).perform_later
    Rails.logger.error('Twitter::Error::TooManyRequestsにより一時停止')
  end

  def perform
    logger = ActiveSupport::Logger.new(Rails.root.join('log/batch.log'))
    logger.info("\n#{DateTime.now} : add_tweets_job")
    registered_tags = RegisteredTag.all.includes(:user, :tag)
    registered_tags.each(&:add_tweets)
  end
end
