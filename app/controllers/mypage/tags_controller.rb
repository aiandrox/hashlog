class Mypage::TagsController < Mypage::BaseController
  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.find_or_initialize_by(tag_params)
    if current_user.create_registered_tag(@tag)
      get_tweets(@tag.name)
      redirect_to mypage_path, notice: t('messages.created', item: @tag.model_name.human)
    else
      flash.now[:alert] = t('messages.not_created', item: @tag.model_name.human)
      render :new
    end
  end

  def get_tweets(tag, user: current_user, until_time: '2020-01-01')
    hashtag = "##{tag}"

  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  # curl -X POST "https://api.twitter.com/1.1/tweets/search/30day/dev.json"\
  # -d '{"query":"#自炊 from:aiandrox","maxResults":"100"}'\
  # -H "Authorization: Bearer AAAAAAAAAAAAAAAAAAAAAOYRDQEAAAAAqOj4OL9iYGT0oYU5gk16giPvUe4%3DZ83FP6MTMJrYI8McD0SEbwkMMys8IKgyud9M4ExUADj8KgOJGU"
  def get_json
    api_key = Rails.application.credentials.twitter[:key]
    api_secret = Rails.application.credentials.twitter[:secret_key]
    token = Rails.application.credentials.twitter[:access_token]
    token_secret = Rails.application.credentials.twitter[:access_token_secret]
    url = 'https://api.twitter.com/1.1/tweets/search/30day/dev.json'
    connection = Faraday.new(url) do |faraday|
      faraday.request :url_encoded
      faraday.request :oauth, { consumer_key: api_key,
                                consumer_secret: api_secret,
                                token: token,
                                token_secret: token_secret }
      faraday.adapter Faraday.default_adapter
    end
    res = connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = { query: "#自炊 from:aiandrox", maxResults: '100' }.to_json
    end
    body = JSON.parse res.body
  end

  def standard
    oauth_consumer_key = Rails.application.credentials.twitter[:key]
    api_secret = Rails.application.credentials.twitter[:secret_key]
    token = Rails.application.credentials.twitter[:access_token]
    token_secret = Rails.application.credentials.twitter[:access_token_secret]
    oauth_nonce = 
    oauth_signature_method = 	"HMAC-SHA1"
    oauth_timestamp = 
    oauth_version = "1.0"
    url = 'https://api.twitter.com/1.1/search/tweets.json?q=from%3aiandrox&result_type=recent'
    connection = Faraday.new(url) do |faraday|
      faraday.request :url_encoded
      faraday.request :oauth, { consumer_key: api_key,
                                consumer_secret: api_secret,
                                token: token,
                                token_secret: token_secret }
      faraday.adapter Faraday.default_adapter
    end
    res = connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = { query: "#自炊 from:aiandrox", maxResults: '100' }.to_json
    end
    body = JSON.parse res.body
  end

  def bearer_token
    uri = URI.parse("https://api.twitter.com/oauth2/token")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded;charset=UTF-8"
    request["Authorization"] = "Basic #{@base64_token}"
    request.set_form_data("grant_type": "client_credentials")
    req_options = { use_ssl: uri.scheme == "https" }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    body = JSON.load(response.body)
    @access_token = body['access_token']
  end


  def create_tweet(tag)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.credentials.twitter[:key]
      config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
      config.access_token        = Rails.application.credentials.twitter[:access_token]
      config.access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
    end
    client.search("##{tag} from:aiandrox", result_type: "recent").take(3).collect do |tweet|
      @tweet = @registered_tag.tweets.build
      @tweet.content = tweet.text
      @tweet.created_at = tweet.created_at
      @tweet.save!
    end
  end

# client.premium_search("#自炊 from:aiandrox", { maxResults: 100 }, { product: '30day' })
end
