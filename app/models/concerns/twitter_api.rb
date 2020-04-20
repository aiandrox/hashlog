require 'twitter'

module TwitterAPI
  extend ActiveSupport::Concern

  # return [["<a href=\"https://twitter.com/hashtag/%E3%83%86%E3%82%B9%E3%83%88?src=hash&amp;ref_src=twsrc%5Etfw\">#テスト</a>", 2020-04-13 07:13:39 UTC, 1249596597479956481],
  #         ["あ<a href=\"https://twitter.com/hashtag/%E3%83%86%E3%82%B9%E3%83%88?src=hash&amp;ref_src=twsrc%5Etfw\">#テスト</a>", 2020-04-12 01:54:07 UTC, 1249153794946011137]]
  def tweets_data(tweet_oembeds = [])
    tweet_ids = search_result('standard')[:tweet_ids]
    tweeted_ats = search_result('standard')[:tweeted_ats]
    client.oembeds(tweet_ids,
                   omit_script: true,
                   hide_thread: true,
                   lang: :ja).take(100).map do |oembed|
      oembed.html =~ %r{\" dir=\"ltr\">(.+)</p>}
      tweet_oembeds << $+
    end
    tweet_oembeds.zip(tweeted_ats, tweet_ids)
    # TODO: twitterAPIリクエスト上限によるエラーの処理
  end

  # return
  # {:tweeted_ats=>[2020-04-14 00:05:51 UTC, 2020-04-12 23:36:38 UTC, 2020-04-12 09:03:19 UTC],
  # :tweet_ids=>[1249851323505201153, 1249481582278144000, 1249261807857889280]}
  def search_result(type)
    if type == 'standard'
      standard_search
    elsif type == '30day'
      premium_search
    end
  end

  def standard_search(tweet_ids = [], tweeted_ats = [])
    @standard_search ||= begin
      client.search("##{tag.name} from:#{user.screen_name}",
                    result_type: 'recent').take(100).map do |result|
        tweeted_ats << result.created_at
        tweet_ids << result.id
      end
      @standard_search = { tweeted_ats: tweeted_ats, tweet_ids: tweet_ids }
    end
  end

  def premium_search(tweet_ids = [], tweeted_ats = [])
    @premium_search ||= begin
      client.premium_search("##{tag.name} from:#{user.screen_name}",
                            { maxResults: 100 },
                            { product: '30day' }).take(100).map do |result|
        tweeted_ats << result.created_at
        tweet_ids << result.id
      end
      @premium_search = { tweeted_ats: tweeted_ats, tweet_ids: tweet_ids }
    end
  end

  def client
    @client ||= begin
      Twitter::REST::Client.new do |config|
        config.consumer_key        = Rails.application.credentials.twitter[:key]
        config.consumer_secret     = Rails.application.credentials.twitter[:secret_key]
        config.access_token        = Rails.application.credentials.twitter[:access_token]
        config.access_token_secret = Rails.application.credentials.twitter[:access_token_secret]
        config.dev_environment     = 'dev'
      end
    end
  end
end
