class HashtagLog < ApplicationRecord
  has_one :hashtags_users, dependent: :destroy
  belongs_to :user
  has_one :hashtag, through: :hashtags_users

  validates :tweeted_day_count, presence: true
  validates :privacy, presence: true
  validates :remind_day, presence: true

  enum privacy: { published: 0, closed: 1, limited: 2 }
end
