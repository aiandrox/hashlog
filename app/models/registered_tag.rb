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
    tweet_results.each do |oembed, tweeted_at|
      tweets.create!(oembed: oembed, tweeted_at: tweeted_at)
    end
  end

  def tweet_results
    @tweet_ids = []
    @tweeted_ats = []
    @tweet_oembeds = []
    search_tweet('standard')
    twitter_client.oembeds(@tweet_ids,
                           omit_script: true,
                           hide_thread: true,
                           lang: :ja).take(100).collect do |oembed|
      @tweet_oembeds << oembed.html
    end
    @tweet_oembeds.zip(@tweeted_ats)
  end

  def search_tweet(type)
    if type == 'standard'
      twitter_client.search("##{tag.name} from:#{user.screen_name}",
                            result_type: 'recent').take(100).collect do |result|
        @tweeted_ats << result.created_at
        @tweet_ids << result.id
      end
    elsif type == '30day'
      twitter_client.premium_search("##{tag.name} from:#{user.screen_name}",
                                    { maxResults: 100 },
                                    { product: '30day' }).take(100).collect do |result|
        @tweeted_ats << result.created_at
        @tweet_ids << result.id
      end
    end
  end

  def twitter_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:key]
      config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
      config.access_token        = Rails.application.credentials.twitter[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
      config.dev_environment     = 'dev'
    end
  end
end
