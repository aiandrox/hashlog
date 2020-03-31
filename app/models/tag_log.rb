class TagLog < ApplicationRecord
  belongs_to :user
  has_one :tag_user, dependent: :destroy
  has_one :tag, through: :tag_user

  validates :tweeted_day_count, presence: true
  validates :privacy, presence: true
  validates :remind_day, presence: true

  enum privacy: { published: 0, closed: 1, limited: 2 }
end
