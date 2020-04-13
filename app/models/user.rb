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

  def registered_tag(tag: nil, tag_name: nil)
    @registered_tag ||= begin
      tag = Tag.find_by(name: tag_name) if tag_name
      @registered_tag = registered_tags.find_by(tag_id: tag.id)
    end
  end

  def set_uuid
    self.uuid = loop do
      random_token = SecureRandom.urlsafe_base64(9)
      break random_token unless self.class.exists?(uuid: random_token)
    end
  end

  def create_registered_tag(tag_name)
    ActiveRecord::Base.transaction do
      tags << tag = Tag.find_or_initialize_by(name: tag_name)
      save!
      registered_tag(tag: tag).create_tweets
      # 上の行の代わりに
      # registered_tag.tweets.auto_save!
    rescue ActiveRecord::RecordInvalid
      if registered_tag(tag_name: tag_name).&invalid?
        tag.errors.messages.merge!(registered_tag.errors.messages)
      end
      false
    rescue StandardError
      render status: 500
      # TODO twitterAPIリクエスト上限によるエラーの処理（ここで処理するものではないが）
    end
  end
end
