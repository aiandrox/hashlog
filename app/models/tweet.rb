class Tweet < ApplicationRecord
  belongs_to :registered_tag

  validates :oembed, presence: true
  validates :tweet_id, presence: true
  validates :tweet_id, uniqueness: { scope: :registered_tag_id }
  validates :tweeted_at, presence: true

  scope :desc, -> { order(tweeted_at: :desc) }
  scope :tweeted_day_count, lambda {
    formated_date = "date_format(tweeted_at, '%Y%m%d')"
    select(formated_date).group(formated_date).length
  }
  scope :tweeted_ats, -> { select(:tweeted_at) }
  scope :tweeted_at_date, ->(date) { where(tweeted_at: date.beginning_of_day..date.end_of_day) }

  def self.latest
    desc.first
  end

  def self.oldest
    desc.last
  end
end
