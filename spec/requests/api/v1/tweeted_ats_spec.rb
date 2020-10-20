RSpec.describe 'TweetedAts', type: :request do
  describe 'GET /api/v1/registered_tags/:regsitered_tag_id/tweeted_ats' do
    let(:registered_tag) { create(:registered_tag) }
    let(:tweeted_ats_json) { json['tweetedAts'] }
    let(:tweets) { registered_tag.tweets }
    describe '全般的なこと' do
      before do
        create_list(:tweet, 10, registered_tag: registered_tag)
        get "/api/v1/registered_tags/#{registered_tag.id}/tweeted_ats"
      end
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'tweeted_atのJSONを返す' do
        tweeted_ats_json.zip(tweets).each do |tweet_json, tweet|
          expect(tweet_json).to include tweet.tweeted_at.to_s[0..9]
        end
      end
    end
  end
end
