class User < ApplicationRecord
  before_create :set_uuid
  before_save :replace_user_data

  authenticates_with_sorcery!
  has_one :authentication, dependent: :destroy
  accepts_nested_attributes_for :authentication
  has_many :registered_tags, dependent: :destroy
  has_many :tags, through: :registered_tags

  validates :twitter_id, presence: true, uniqueness: true
  validates :screen_name, presence: true
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 300 }
  validates :privacy, presence: true
  validates :role, presence: true

  enum privacy: { published: 0, closed: 1 }
  enum role: { admin: 0, general: 1, deleted: 10 }

  scope :not_deleted, -> { where.not(role: :deleted) }

  # tagからregistered_tagを返す
  def registered_tag(tag)
    @registered_tag ||= begin
      return nil if tag.invalid?

      # 存在しない場合はnilを返すので!は付けない
      registered_tags.find_by(tag_id: tag.id)
    end
  end

  def register_tag(tag)
    ActiveRecord::Base.transaction do
      tag.save!
      registered_tag = registered_tags.build(tag_id: tag.id)
      registered_tag.save!
      tweets_data = TwitterAPI::UserTweets.new(self, registered_tag.tag.name).call # ('premium')
      registered_tag.create_tweets(tweets_data)
      true
    rescue ActiveRecord::RecordInvalid
      tag.errors.messages.merge!(registered_tag.errors.messages) if tag.valid?
      false
    end
  end

  # has_manyが増えたら引数を汎用的（object）にすること
  def my_object?(registered_tag)
    registered_tag.user == self
  end

  private

  def set_uuid
    self.uuid = loop do
      random_token = SecureRandom.urlsafe_base64(9)
      break random_token unless self.class.exists?(uuid: random_token)
    end
  end

  def replace_user_data
    description.gsub!(/[　 \n]+$/, '')
    avatar_url&.sub!(/_normal(.jpg|.jpeg|.gif|.png)/i) { Regexp.last_match[1] }
  end
end
