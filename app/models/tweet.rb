class Tweet < ApplicationRecord
  belongs_to :registered_tag

  validates :oembed, presence: true
  validates :tweet_id, presence: true
  # TODO: うまくいっていない
  def self.tweeted_day_count
    group_by{ |tweet| tweet.tweeted_at.to_date }.count
  end
end
