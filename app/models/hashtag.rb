class Hashtag < ApplicationRecord
  has_many :hashtag_users
  has_many :users, through: :hashtag_users
  has_many :hashtag_logs, through: :hashtag_users

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end
