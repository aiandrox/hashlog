class RegisteredTag < ApplicationRecord
  has_many :tweets, dependent: :destroy
  belongs_to :user
  belongs_to :tag

  validates :tweeted_day_count, presence: true
  validates :privacy, presence: true
  validates :remind_day, presence: true
  validates :tag_id, uniqueness: { scope: :user_id, message: 'を既に登録しています' }

  enum privacy: { published: 0, closed: 1, limited: 2 }

  def get_tweets
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:key]
      config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
      config.access_token        = Rails.application.credentials.twitter[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
    end
    tweet_ids = []
    tweeted_ats = []
    client.search("##{tag.name} from:#{user.screen_name}",
                  result_type: 'recent').take(100).collect do |result|
      tweeted_ats << result.created_at
      tweet_ids << result.id
    end
    client.oembeds(tweet_ids, omit_script: true).take(100).collect do |oembed|
      n = 0
      tweet = Tweet.new(registered_tag_id: id) # TODO　アソシエーションがだめ。tweet = tweets.buildがダメだった
      tweet.tweeted_at = tweeted_ats.delete_at(n)
      tweet.oembed = oembed.html
      tweet.save!
      n += 1
    end
  end

  def premium_tweet
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:key]
      config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
      config.dev_environment     = 'dev'
    end
    client.premium_search("##{tag.name} from:#{user.screen_name}",
                          { maxResults: 100 },
                          { product: '30day' }).take(100).collect do |date|
      client.status(date.id)

      tweet = Tweet.new(registered_tag_id: id) # TODO　アソシエーションがだめ。tweet = tweets.buildがダメだった
      tweet.content = date.text
      tweet.created_at = date.created_at
      tweet.save!
    end
  end

  def tweet_json(tweet_id)
    url = "https://publish.twitter.com/oembed?url=https%3A%2F%2Ftwitter.com%2FInterior%2Fstatus%2F#{tweet_id}"
    uri = URI.parse(url)
    json = Net::HTTP.get(uri)
    JSON.parse(json)
  end
end
