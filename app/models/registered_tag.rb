class RegisteredTag < ApplicationRecord
  before_validation :filter_remind_day

  has_many :tweets, dependent: :destroy
  belongs_to :user
  belongs_to :tag

  validates :privacy, presence: true
  validates :remind_day, numericality: { only_integer: true, less_than_or_equal_to: 30 }
  validates :tag_id, uniqueness: { scope: :user_id, message: 'は既に登録しています' }
  validate :user_registered_tags_count_validate, on: :create

  enum privacy: { published: 0, closed: 1, limited: 2 }

  scope :asc, -> { order(created_at: :asc) }
  scope :desc, -> { order(created_at: :desc) }
  scope :opened, -> { published.joins(:user).where('users.privacy = ?', 0) }

  def last_tweeted_at
    @last_tweeted_at ||= tweets.latest&.tweeted_at
  end

  def tweeted_day_count
    @tweeted_day_count ||= tweets&.tweeted_day_count
  end

  def day_from_last_tweet
    last_tweeted_at.nil? ? 0 : (Date.today - last_tweeted_at.to_date).to_i
  end

  def day_from_first_tweet
    first_tweeted_at.nil? ? 0 : (Date.today - first_tweeted_at.to_date).to_i + 1
  end

  def tweet_rate
    return 0 if day_from_first_tweet.zero?

    # 今日のデータがない場合は昨日時点までのデータで計算する
    denominator = day_from_last_tweet.zero? ? day_from_first_tweet : day_from_first_tweet - 1
    (tweeted_day_count.to_f / denominator * 100).round(1)
  end

  def cron_tweets
    last_tweet = tweets.latest

    unless last_tweet
      create_tweets!
      return
    end

    return if last_tweet.tweeted_at > Time.current.prev_day.beginning_of_day

    since_id = last_tweet.tweet_id.to_i
    add_tweets(since_id).any? && Rails.logger.info("@#{user.screen_name} の ##{tag.name} にツイートを追加")
  end

  def create_tweets!(type = 'standard')
    client = TwitterAPI::Search.new(user, tag.name)
    client.tweets_data(type).each do |oembed, tweeted_at, tweet_id|
      tweets.create!(oembed: oembed, tweeted_at: tweeted_at, tweet_id: tweet_id)
    end
  end

  def add_tweets(since_id)
    client = TwitterAPI::Search.new(user, tag.name, since_id)
    client.tweets_data('everyday').each do |oembed, tweeted_at, tweet_id|
      tweets.create(oembed: oembed, tweeted_at: tweeted_at, tweet_id: tweet_id)
    end
  end

  def fetch_tweets_data!
    update!(first_tweeted_at: tweets.oldest.tweeted_at) if tweets.any?
  end

  private

  def filter_remind_day
    self.remind_day = 0 if remind_day.nil?
  end

  def user_registered_tags_count_validate
    errors.add(:base, '登録できるハッシュタグは3つまでです') if user&.registered_tags&.count.to_d >= 3
  end
end
