class RemindReplyJob < ApplicationJob
  queue_as :default

  # TODO: 重複してリプライを送ることになる。制限は300リクエストなので保留
  # rescue_from Twitter::Error::TooManyRequests do
  #   logger.error("RemindReplyJob: Twitter::Error::TooManyRequests\n3時間後に再試行します")
  #   retry_job wait: 3.hours, queue: :low_priority
  # end

  def perform
    logger.info("\n#{DateTime.now} : RemindReplyJob")
    TwitterAPI::RemindReply.new.call
  end
end
