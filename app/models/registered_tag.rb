class RegisteredTag < ApplicationRecord
  has_many :tweets, dependent: :destroy
  belongs_to :user
  belongs_to :tag

  validates :tweeted_day_count, presence: true
  validates :privacy, presence: true
  validates :remind_day, presence: true
  validates :tag_id, uniqueness: { scope: :user_id, message: 'を既に登録しています' }

  enum privacy: { published: 0, closed: 1, limited: 2 }

  scope :asc, -> { order(created_at: :asc) }

  def create_tweets(type = 'standard')
    client = TwitterAPI::Client.new(user, tag.name)
    client.tweets_data(type).each do |oembed, tweeted_at, tweet_id|
      tweets.create!(oembed: oembed, tweeted_at: tweeted_at, tweet_id: tweet_id)
    end
  end

  # cron処理用
  def add_tweets
    last_tweet = tweets.latest

    unless last_tweet
      create_tweets
      return
    end

    return if last_tweet.tweeted_at > Date.yesterday

    since_id = last_tweet.tweet_id.to_i
    client = TwitterAPI::Client.new(user, tag.name, since_id)
    client.tweets_data('everyday').each do |oembed, tweeted_at, tweet_id|
      tweets.create(oembed: oembed, tweeted_at: tweeted_at, tweet_id: tweet_id)
    end

    return if client.tweets_data('everyday').empty?

    fetch_data('add')
    Rails.logger.info("@#{user.screen_name} の ##{tag.name} にツイートを追加")
  end

  def fetch_data(type = 'new')
    self.first_tweeted_at = tweets.oldest.tweeted_at if type == 'new'
    self.last_tweeted_at = tweets.latest.tweeted_at
    self.tweeted_day_count = tweets.tweeted_day_count
  end
end
