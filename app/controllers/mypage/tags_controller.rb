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

  def access_token
    api_key = Rails.application.credentials.twitter[:key]
    api_secret = Rails.application.credentials.twitter[:secret_key]
    @base64_token = Base64.strict_encode64("#{api_key}:#{api_secret}")
    @access_token ||= get_access_token
  end

  # curl --request 'POST' 'https://api.twitter.com/oauth2/token'\
  # --header 'Authorization: Basic base64_token'\
  # --header 'Content-Type: application/x-www-form-urlencoded;charset=UTF-8'\
  # --data "grant_type=client_credentials" --verbose
  def get_access_token
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
  
  def res
    binding.pry
    uri = URI.parse("https://api.twitter.com/1.1/tweets/search/30day/dev.json")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{Rails.application.credentials.twitter[:bearer_access_token]}"
    request.body = JSON.dump({
      "query" => "#自炊 from:aiandrox",
      "maxResults" => "100"
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response
  end
end
