module LoggerHelper
  private

  attr_reader :slack_notifier

  def logger
    @logger = ActiveSupport::Logger.new(Rails.root.join('log/batch.log'))
    console = ActiveSupport::Logger.new(STDOUT) # この二行がないとlogger.infoが反映されない
    @logger.extend ActiveSupport::Logger.broadcast(console)
    @logger.level = Rails.logger.level # この二行でRails.loggerで出力したものを拾う
    Rails.logger = @logger
    @logger
  end

  def slack_notify(logs)
    logs = '特にありませんでした。' if logs.nil? || logs == ''

    notifier = Slack::Notifier.new(Rails.application.credentials.slack_notifier[:webhook_url],
                                   channel: '#hashlog通知',
                                   username: '定期実行通知')
    notifier.ping(logs)
  end
end
