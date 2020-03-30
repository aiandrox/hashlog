class Log < ApplicationRecord
  has_one :hashtags_users
  belongs_to :user

  validates :tweeted_day_count, presence: true
  validates :privacy, presence: true
  validates :remind_day, presence: true

  enum privacy: { published: 0, closed: 1, limited: 2 }
end
