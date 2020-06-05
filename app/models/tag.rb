class Tag < ApplicationRecord
  has_many :registered_tags, dependent: :restrict_with_error
  has_many :users, through: :registered_tags

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
end
