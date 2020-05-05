RSpec.describe 'Tweets', type: :request do
  describe 'GET /api/v1/registered_tags/:registered_tag_id/tweets' do
    let(:registered_tag) { create(:registered_tag, :with_tweets) }
    let(:tweets_json) { json['tweets'] }
    let(:tweets) { registered_tag.tweets.desc }
    let!(:latest_registered_tweet) {
      create(:tweet, registered_tag: registered_tag, tweeted_at: Date.tomorrow)
    }
    let!(:oldest_registered_tweet) {
      create(:tweet, :tweeted_yesterday, registered_tag: registered_tag)
    }
    before do
      create_list(:tweet, 3)
      get "/api/v1/registered_tags/#{registered_tag.id}/tweets"
    end
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'RegisteredTag.find(params[:registered_tag_id]).tweets.descのJSONを返す' do
      expect(tweets_json.length).to eq 5
      tweets_json.zip(tweets).each do |tweet_json, tweet|
        expect(tweet_json).to eq({
          'id' => tweet.id,
          'tweetId'=> tweet.tweet_id,
          'oembed' => tweet.oembed,
          'tweetedAt' => tweet.tweeted_at.as_json,
        })
      end
    end
    it 'tweetsが昇順に並ぶ' do
      expect(tweets_json.first['id']).to eq latest_registered_tweet.id
      expect(tweets_json.last['id']).to eq oldest_registered_tweet.id
    end
  end
end
