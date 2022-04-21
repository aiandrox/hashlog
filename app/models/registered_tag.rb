# == Schema Information
#
# Table name: registered_tags
#
#  id               :bigint           not null, primary key
#  first_tweeted_at :datetime
#  last_tweeted_at  :datetime
#  privacy          :integer          default("published"), not null
#  remind_day       :integer          default(0), not null
#  tweet_rate       :float(24)        default(0.0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tag_id           :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_registered_tags_on_created_at          (created_at)
#  index_registered_tags_on_tag_id              (tag_id)
#  index_registered_tags_on_user_id             (user_id)
#  index_registered_tags_on_user_id_and_tag_id  (user_id,tag_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#  fk_rails_...  (user_id => users.id)
#
class RegisteredTag < ApplicationRecord
  DAY_COUNT_MONTH = 30
  NONE = 0
  FULL = 1
  FULL_PER = 100
  USER_REGISTERED_TAGS_COUNT = 10
  [DAY_COUNT_MONTH, NONE, FULL, FULL_PER, USER_REGISTERED_TAGS_COUNT].each(&:freeze)

  before_validation :filter_remind_day

  has_many :tweets, dependent: :destroy
  belongs_to :user
  belongs_to :tag

  validates :privacy, presence: true
  validates :remind_day, numericality: { only_integer: true,
                                         less_than_or_equal_to: DAY_COUNT_MONTH }
  validates :tag_id, uniqueness: { case_sensitive: true, scope: :user_id, message: 'は既に登録しています' }
  validate :user_registered_tags_count_validate, on: :create

  enum privacy: { published: 0, closed: 1, limited: 2 }

  scope :asc, -> { order(created_at: :asc) }
  scope :desc, -> { order(created_at: :desc) }
  scope :opened, -> { published.joins(:user).where('users.privacy = ?', 0) }
  scope :day_count_sort, -> {
    joins(:tweets).group(:id).order(Arel.sql("count(distinct date_format(tweets.tweeted_at, '%Y%m%d')) desc, registered_tags.tweet_rate desc"))
  }
  scope :persistence_sort, -> {
    joins(:tweets).group(:id).order(Arel.sql("registered_tags.tweet_rate desc, count(distinct date_format(tweets.tweeted_at, '%Y%m%d')) desc"))
  }

  class << self
    def tweet_rate(registered_tag)
      # ツイートがない場合は0%
      return NONE if registered_tag.first_tweeted_at.nil?
      # 最初のツイートと最後のツイートが今日の場合は100%にする
      return FULL if (registered_tag.day_from_first_tweet - registered_tag.day_from_last_tweet).zero?

      # 今日のデータがない場合は昨日時点までのデータで計算する
      denominator = registered_tag.day_from_last_tweet.zero? ? registered_tag.day_from_first_tweet : registered_tag.day_from_first_tweet - 1
      (registered_tag.tweeted_day_count.to_f / denominator * FULL_PER).round(1)
    end
  end

  def tweeted_day_count
    tweets.tweeted_day_count
  end

  def day_from_last_tweet
    last_tweeted_at.nil? ? NONE : (Date.today - last_tweeted_at.to_date).to_i
  end

  def day_from_first_tweet
    first_tweeted_at.nil? ? NONE : (Date.today - first_tweeted_at.to_date).to_i + 1
  end

  def remind_reply?
    remind_day.positive? && remind_day < day_from_last_tweet && day_from_last_tweet < remind_day + 5
  end

  def create_tweets(tweets_data_array)
    tweets_data_array.each do |oembed, tweeted_at, tweet_id, medias|
      tweets.create_with_images!(
        oembed: oembed,
        tweeted_at: tweeted_at,
        tweet_id: tweet_id,
        medias: medias
      )
    end
  end

  private

  def filter_remind_day
    self.remind_day = NONE if remind_day.nil?
  end

  def user_registered_tags_count_validate
    return unless user&.registered_tags&.count.to_d >= USER_REGISTERED_TAGS_COUNT

    errors.add(:base, "登録できるハッシュタグは#{USER_REGISTERED_TAGS_COUNT}個までです")
  end
end
