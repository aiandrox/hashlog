class RegisteredTag < ApplicationRecord
  before_validation :filter_remind_day

  has_many :tweets, dependent: :destroy
  belongs_to :user
  belongs_to :tag

  validates :tweeted_day_count, presence: true
  validates :privacy, presence: true
  validates :remind_day, presence: true,
                         numericality: { only_integer: true, less_than_or_equal_to: 30 }
  validates :tag_id, uniqueness: { scope: :user_id }

  enum privacy: { published: 0, closed: 1, limited: 2 }

  scope :asc, -> { order(created_at: :asc) }

  def self.by_user(user_uuid)
    if user_uuid
      includes(:user).where(users: { uuid: user_uuid })
    else
      all
    end
  end

  # 最初にツイートした日から経過した日数
  def all_day_count
    return 0 if first_tweeted_at.nil?

    first = first_tweeted_at.to_date
    today = Date.current
    (today - first).to_i
  end

  # ツイート率 今日のツイートはまだ取得できていないため、all_day_count-1をする
  # TODO: 取得した日は場合によっては100％を超えそう
  def tweet_rate
    tweeted_day_count * 100 / (all_day_count - 1)
  end

  # TODO: サービスクラス
  def cron_tweets
    last_tweet = tweets.latest

    unless last_tweet
      create_tweets
      return
    end

    return if last_tweet.tweeted_at > DateTime.yesterday

    since_id = last_tweet.tweet_id.to_i
    add_tweets(since_id)

    return if add_tweets(since_id).empty?

    fetch_data('add')
    Rails.logger.info("@#{user.screen_name} の ##{tag.name} にツイートを追加")
  end

  def create_tweets(type = 'standard')
    client = TwitterAPI::Client.new(user, tag.name)
    client.tweets_data(type).each do |oembed, tweeted_at, tweet_id|
      tweets.create!(oembed: oembed, tweeted_at: tweeted_at, tweet_id: tweet_id)
    end
  end

  def fetch_data(type = 'new')
    self.first_tweeted_at = tweets.oldest.tweeted_at if type == 'new'
    self.last_tweeted_at = tweets.latest.tweeted_at
    self.tweeted_day_count = tweets.tweeted_day_count
  end

  def add_tweets(since_id)
    client = TwitterAPI::Client.new(user, tag.name, since_id)
    client.tweets_data('everyday').each do |oembed, tweeted_at, tweet_id|
      tweets.create(oembed: oembed, tweeted_at: tweeted_at, tweet_id: tweet_id)
    end
  end

  private

  def filter_remind_day
    self.remind_day = remind_day
  end
end
