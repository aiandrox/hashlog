class Hashtag < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :logs, through: :hashtags_users

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end
