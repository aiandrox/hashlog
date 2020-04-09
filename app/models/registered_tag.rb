class RegisteredTag < ApplicationRecord
  has_many :tweets, dependent: :destroy
  belongs_to :user
  belongs_to :tag

  validates :tweeted_day_count, presence: true
  validates :privacy, presence: true
  validates :remind_day, presence: true
  validates :tag_id, uniqueness: { scope: :user_id, message: 'を既に登録しています' }

  enum privacy: { published: 0, closed: 1, limited: 2 }

  # curl -X POST "https://api.twitter.com/1.1/tweets/search/30day/dev.json"\
  # -d '{"query":"#自炊 from:aiandrox","maxResults":"100"}'\
  # -H "Authorization: Bearer AAAAAAAAAAAAAAAAAAAAAOYRDQEAAAAAqOj4OL9iYGT0oYU5gk16giPvUe4%3DZ83FP6MTMJrYI8McD0SEbwkMMys8IKgyud9M4ExUADj8KgOJGU"
  def tweets
    
  end

  def connection
    api_key = Rails.application.credentials.twitter[:key]
    api_secret = Rails.application.credentials.twitter[:secret_key]
    token = Rails.application.credentials.twitter[:access_token]
    token_secret = Rails.application.credentials.twitter[:access_token_secret]
    url = 'https://api.twitter.com/1.1/tweets/search/30day/dev.json'
    Faraday.new(url) do |faraday|
      faraday.request :url_encoded
      faraday.request :oauth, { consumer_key: api_key,
                                consumer_secret: api_secret,
                                token: token,
                                token_secret: token_secret }
      faraday.adapter Faraday.default_adapter
    end
  end

  def response_result
    res = connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = { query: "#自炊 from:aiandrox", maxResults: '100' }.to_json
    end
    body = JSON.parse res.body
  end
end
