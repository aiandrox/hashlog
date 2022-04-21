module Job
  class RemindReply
    attr_reader :notify_logs

    def initialize(registered_tags = RegisteredTag.all.includes(:user, :tag))
      @registered_tags = registered_tags
      @notify_logs = []
    end

    def call
      registered_tags.each do |tag|
        send_tweet(tag) if tag.remind_reply?
      end
    end

    private

    attr_reader :registered_tags

    def send_tweet(r_tag)
      TwitterApiClient.client.update(remind_message(r_tag))
      message = "@#{r_tag.user.screen_name} の ##{r_tag.tag.name} にリマインド送信"
      Rails.logger.info(message)
      notify_logs << message
    rescue StandardError => e
      message = "@#{r_tag.user.screen_name} の ##{r_tag.tag.name}: #{e}"
      notify_logs << message && Rails.logger.error(message)
    end

    def remind_message(r_tag)
      day = r_tag.day_from_last_tweet == 1 ? '丸1日' : "#{r_tag.day_from_last_tweet}日間"
      url = "https://hashlog.work/mypage/tags/#{r_tag.id}"
      "@#{r_tag.user.screen_name}\n##{r_tag.tag.name} のツイートが#{day}途絶えているようです。調子はいかがですか？
\n通知を解除する場合は以下のリンクから設定してください。\n#{url}"
    end
  end
end
