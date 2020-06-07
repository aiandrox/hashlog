RSpec.describe 'Tweets', type: :request do
  describe 'GET /api/v1/registered_tags/:registered_tag_id/tweets' do
    let(:registered_tag) { create(:registered_tag) }
    let(:tweets_json) { json['tweets'] }
    let(:tweets) { registered_tag.tweets.desc }
    before do
      create_list(:tweet, 30, registered_tag: registered_tag)
      get "/api/v1/registered_tags/#{registered_tag.id}/tweets"
    end
    describe 'pagy' do
      it 'pageクエリがないとき 10件返す' do
        expect(tweets_json.length).to eq 10
      end
      it 'page=2のとき 10件返す' do
        get "/api/v1/registered_tags/#{registered_tag.id}/tweets?page=2"
        expect(tweets_json.length).to eq 10
      end
    end
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'RegisteredTag.find(params[:registered_tag_id]).tweets.descのJSONを返す' do
      expect(tweets_json.length).to eq 10
      tweets_json.zip(tweets).each do |tweet_json, tweet|
        expect(tweet_json).to eq({
          'id' => tweet.id,
          'tweetId' => tweet.tweet_id,
          'oembed' => tweet.oembed,
          'tweetedAt' => tweet.tweeted_at.as_json,
        })
      end
    end
    describe 'ソート' do
      let!(:latest_registered_tweet) {
        create(:tweet, registered_tag: registered_tag, tweeted_at: Date.tomorrow)
      }
      let!(:oldest_registered_tweet) {
        create(:tweet, :tweeted_yesterday, registered_tag: registered_tag)
      }
      it 'tweetsが昇順に並ぶ（最新のtweetが最初になる）' do
        get "/api/v1/registered_tags/#{registered_tag.id}/tweets"
        expect(tweets_json.first['id']).to eq latest_registered_tweet.id
      end
      it 'tweetsが昇順に並ぶ（最古のtweetが最後になる）' do
        get "/api/v1/registered_tags/#{registered_tag.id}/tweets?page=4"
        expect(tweets_json.last['id']).to eq oldest_registered_tweet.id
      end
    end
  end
end
