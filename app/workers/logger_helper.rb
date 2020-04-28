module LoggerHelper
  private

  attr_reader :logger

  def initialize
    set_logger
  end

  def set_logger
    @logger = ActiveSupport::Logger.new(Rails.root.join('log/batch.log'))
    console = ActiveSupport::Logger.new(STDOUT) # この二行がないとlogger.infoが反映されない
    @logger.extend ActiveSupport::Logger.broadcast(console)
    @logger.level = Rails.logger.level # この二行でRails.loggerで出力したものを拾う
    Rails.logger = @logger
  end
end
