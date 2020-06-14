class Tag < ApplicationRecord
  before_validation :remove_first_hashtag_mark

  has_many :registered_tags, dependent: :restrict_with_error
  has_many :users, through: :registered_tags

  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }

  # TODO: 警告を直す
  scope :popular, -> { joins(:registered_tags).group(:tag_id).order('count(user_id) DESC') }

  private

  def remove_first_hashtag_mark
    name&.gsub!(/^#+/, '')
  end
end
