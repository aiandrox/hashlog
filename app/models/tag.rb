class Tag < ApplicationRecord
  has_many :tag_users
  has_many :users, through: :tag_users
  has_many :tag_logs, through: :tag_users

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end
