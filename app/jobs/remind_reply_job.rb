class RemindReplyJob < ApplicationJob
  queue_as :default

  # TODO: 重複してリプライを送ることになる。制限は300リクエストなので保留
  # rescue_from Twitter::Error::TooManyRequests do
  #   logger.error("RemindReplyJob: Twitter::Error::TooManyRequests\n3時間後に再試行します")
  #   retry_job wait: 3.hours, queue: :low_priority
  # end

  def perform
    logger.info("\n#{Time.now} : RemindReplyJob")
    remind_reply = TwitterAPI::RemindReply.new
    remind_reply.call
    message = remind_reply.notify_logs.join("\n")
    slack_notify(message)
  end
end
