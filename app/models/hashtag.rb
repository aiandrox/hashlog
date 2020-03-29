class Hashtag < ApplicationRecord
  has_many :users, through: :user_hashtags
  has_many :user_hashtags
  accepts_nested_attributes_for :user_hashtags

  validates :name, presence: true, unique: true
end
