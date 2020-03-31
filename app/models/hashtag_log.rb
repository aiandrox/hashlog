class HashtagLog < ApplicationRecord
  belongs_to :user
  has_one :hashtag_users, dependent: :destroy
  has_one :hashtag, through: :hashtag_users

  validates :tweeted_day_count, presence: true
  validates :privacy, presence: true
  validates :remind_day, presence: true

  enum privacy: { published: 0, closed: 1, limited: 2 }
end
