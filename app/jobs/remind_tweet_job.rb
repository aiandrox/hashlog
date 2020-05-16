class RemindTweetJob < ApplicationJob
  queue_as :default

  rescue_from Twitter::Error::TooManyRequests do
    logger.error("RemindTweetJob: Twitter::Error::TooManyRequests\n3時間後に再試行します")
    retry_job wait: 3.hours, queue: :low_priority
  end

  def perform
    logger.info("\n#{DateTime.now} : RemindTweetJob")
    registered_tags = RegisteredTag.all.includes(:user, :tag)
    TwitterAPI::RemindTweet.new(registered_tags).call
  end
end
