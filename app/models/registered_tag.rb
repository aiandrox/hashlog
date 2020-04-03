class RegisteredTag < ApplicationRecord
  has_many :tweets, dependent: :destroy
  belongs_to :user
  belongs_to :tag

  validates :tweeted_day_count, presence: true
  validates :privacy, presence: true
  validates :remind_day, presence: true
  validates :tag_id, uniqueness: { scope: :user_id, message: 'を既に登録しています' }

  enum privacy: { published: 0, closed: 1, limited: 2 }
end
