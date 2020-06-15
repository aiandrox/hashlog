class AddTweetsJob < ApplicationJob
  queue_as :default

  rescue_from Twitter::Error::TooManyRequests do
    logger.error("AddTweetsJob: Twitter::Error::TooManyRequests\n15分後に再試行します")
    retry_job wait: 15.minutes, queue: :low_priority
  end

  def perform(add_tweets = TwitterAPIJob::AddTweets.new)
    logger.info("\n#{Time.now} : AddTweetsJob")
    add_tweets.call
    message = add_tweets.notify_logs.join("\n")
    slack_notify(message)
  end
end
