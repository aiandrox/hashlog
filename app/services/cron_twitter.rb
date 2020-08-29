class CronTwitter
  include LoggerHelper

  def initialize(type)
    case type
    when :add_tweets
      self.job = TwitterAPIJob::AddTweets.new
    when :remind_reply
      self.job = TwitterAPIJob::RemindReply.new
    end
  end

  def call
    logger.info("\n#{Time.now} : #{type}")
    job.call
    message = job.notify_logs.join("\n")
    slack_notify("#{type}\n#{message}")
  rescue Twitter::Error::TooManyRequests
    slack_notify("#{type}: Twitter::Error::TooManyRequests")
  end

  private
  attr_accessor :type, :job
end
