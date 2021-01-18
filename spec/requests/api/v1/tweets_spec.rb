RSpec.describe 'Tweets', type: :request do
  describe 'GET /api/v1/registered_tags/:registered_tag_id/tweets' do
    let(:registered_tag) { create(:registered_tag) }
    let(:tweets_json) { json['tweets'] }
    let(:tweets) { registered_tag.tweets.desc }
    describe '全般的なこと' do
      before do
        create_list(:tweet, 10, registered_tag: registered_tag)
        get "/api/v1/registered_tags/#{registered_tag.id}/tweets"
      end
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'RegisteredTag.find(params[:registered_tag_id]).tweets.descのJSONを返す' do
        tweets_json.zip(tweets).each do |tweet_json, tweet|
          expect(tweet_json).to eq({
            'id' => tweet.id,
            'tweetId' => tweet.tweet_id,
            'oembed' => tweet.oembed,
            'tweetedAt' => tweet.tweeted_at.as_json,
            'images' => []
          })
        end
      end
    end
    context 'date=2020-06-01のとき' do
      let(:the_day) { Time.parse('2020-06-01') }
      let!(:prev_day_tweet) {
        create(:tweet, tweeted_at: the_day.prev_day.end_of_day, registered_tag: registered_tag)
      }
      let!(:beginning_of_day_tweet) {
        create(:tweet, tweeted_at: the_day, registered_tag: registered_tag)
      }
      let!(:end_of_day_tweet) {
        create(:tweet, tweeted_at: the_day.end_of_day, registered_tag: registered_tag)
      }
      let!(:next_day_tweet) {
        create(:tweet, tweeted_at: the_day.next_day, registered_tag: registered_tag)
      }
      before { get "/api/v1/registered_tags/#{registered_tag.id}/tweets?date=2020-06-01" }
      it '指定した日のツイートを返す' do
        expect(tweets_json.length).to eq 2
        expect(tweets_json).to include({
          'id' => beginning_of_day_tweet.id,
          'tweetId' => beginning_of_day_tweet.tweet_id,
          'oembed' => beginning_of_day_tweet.oembed,
          'tweetedAt' => beginning_of_day_tweet.tweeted_at.as_json,
          'images' => []
        })
        expect(tweets_json).to include({
          'id' => end_of_day_tweet.id,
          'tweetId' => end_of_day_tweet.tweet_id,
          'oembed' => end_of_day_tweet.oembed,
          'tweetedAt' => end_of_day_tweet.tweeted_at.as_json,
          'images' => []
        })
      end
      it '指定した日ではないツイートを含まない' do
        expect(tweets_json).not_to include({
          'id' => prev_day_tweet.id,
          'tweetId' => prev_day_tweet.tweet_id,
          'oembed' => prev_day_tweet.oembed,
          'tweetedAt' => prev_day_tweet.tweeted_at.as_json,
          'images' => []
        })
        expect(tweets_json).not_to include({
          'id' => next_day_tweet.id,
          'tweetId' => next_day_tweet.tweet_id,
          'oembed' => next_day_tweet.oembed,
          'tweetedAt' => next_day_tweet.tweeted_at.as_json,
          'images' => []
        })
      end
      context 'date=2000-01-01（ツイートが存在しない）のとき' do
        before { get "/api/v1/registered_tags/#{registered_tag.id}/tweets?date=2000-01-01" }
        it '空配列を返す' do
          expect(tweets_json).to eq []
        end
      end
    end
    describe 'pagy' do
      before { create_list(:tweet, 30, registered_tag: registered_tag) }
      it 'pageクエリがないとき 全件返す' do
        get "/api/v1/registered_tags/#{registered_tag.id}/tweets"
        expect(tweets_json.length).to eq 30
      end
      it 'page=1のとき 10件返す' do
        get "/api/v1/registered_tags/#{registered_tag.id}/tweets?page=1"
        expect(tweets_json.length).to eq 10
      end
      it 'page=2のとき 10件返す' do
        get "/api/v1/registered_tags/#{registered_tag.id}/tweets?page=2"
        expect(tweets_json.length).to eq 10
      end
    end
    describe 'ソート' do
      let!(:latest_registered_tweet) {
        create(:tweet, registered_tag: registered_tag, tweeted_at: Date.tomorrow)
      }
      let!(:oldest_registered_tweet) {
        create(:tweet, :tweeted_yesterday, registered_tag: registered_tag)
      }
      before { create_list(:tweet, 30, registered_tag: registered_tag) }
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

  describe 'POST /api/v1/registered_tags/:registered_tag_id/tweets' do
    let(:user) { create(:user) }
    let(:registered_tag) { create(:registered_tag, user: user, tag: create(:tag, name: 'test')) }
    let(:tweet_json) { json['tweet'] }
    subject { post "/api/v1/registered_tags/#{registered_tag.id}/tweets", params: { tweet: { body: body } } }
    before { login_as(user) }

    xcontext 'with valid', vcr: { cassette_name: 'twitter_api/update' } do
      let(:body) { "#test 本文" }
      it do
        subject
        expect(response.status).to eq 200
      end
      it { expect{ subject }.to change { Tweet.count }.by(1) }
    end
    context 'bodyがblankのとき' do
      let(:body) { '' }
      it do
        subject
        expect(response.status).to eq 422
      end
      it { expect{ subject }.not_to change { Tweet.count } }
      it do

      end
    end
  end
end
