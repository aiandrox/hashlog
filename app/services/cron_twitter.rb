class CronTwitter
  include LoggerHelper

  def call(twitter_api_job)
    logger.info("\n#{Time.current}")
    twitter_api_job.call
    message = twitter_api_job.notify_logs.join("\n")
    slack_notify(message)
  end
end
