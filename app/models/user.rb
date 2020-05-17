class User < ApplicationRecord
  before_create :set_uuid

  authenticates_with_sorcery!
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications
  has_many :registered_tags, dependent: :destroy
  has_many :tags, through: :registered_tags

  validates :twitter_id, presence: true, uniqueness: true
  validates :screen_name, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 300 }
  validates :privacy, presence: true
  validates :role, presence: true

  enum privacy: { published: 0, closed: 1 }
  enum role: { admin: 0, general: 1, guest: 2 }

  def set_uuid
    self.uuid = loop do
      random_token = SecureRandom.urlsafe_base64(9)
      break random_token unless self.class.exists?(uuid: random_token)
    end
  end

  # tagからregistered_tagを返す
  def registered_tag(tag)
    @registered_tag ||= begin
      return nil if tag.invalid?

      registered_tags.find_by(tag_id: tag.id)
    end
  end

  def register_tag(tag)
    ActiveRecord::Base.transaction do
      tag.save!
      registered_tag = registered_tags.create!(tag_id: tag.id)
      registered_tag.create_tweets
      registered_tag.fetch_data if registered_tag.tweets.any?
      registered_tag.save!
      true
    rescue ActiveRecord::RecordInvalid
      tag.errors.messages.merge!(registered_tag.errors.messages) if tag.valid?
      false
    end
  end
end
