RSpec.describe 'RegisteredTags', type: :request do
  fdescribe 'GET /api/v1/registered_tags/persistences' do
    let(:registered_tags) { RegisteredTag.opened.includes(:user, :tag).have_tweets.persistence_sort }
    let(:tags_json) { json['registeredTags'] }
    before do
      create_list(:registered_tag, 50)
      get '/api/v1/registered_tags/persistences'
    end
    describe '全般的なこと' do
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'RegisteredTag.ascのJSONを返す' do
        tags_json.zip(registered_tags).each do |tag_json, registered_tag|
          expect(tag_json).to eq({
            'id' => registered_tag.id,
            'tweetedDayCount' => registered_tag.tweeted_day_count,
            'privacy' => registered_tag.privacy_i18n,
            'remindDay' => nil,
            'tweetRate' => 0,
            'firstTweetedAt' => registered_tag.first_tweeted_at,
            'lastTweetedAt' => registered_tag.last_tweeted_at,
            'tag' => {
              'id' => registered_tag.tag.id,
              'name' => registered_tag.tag.name,
            },
            'user' => {
              'name' => registered_tag.user.name,
              'uuid' => registered_tag.user.uuid,
              'avatarUrl' => 'https://abs.twimg.com/sticky/default_profile_images/default_profile.png'
            }
          })
        end
      end
    end
    describe 'ソート' do
      let!(:registered_tag_with_no_tweets) { create(:registered_tag) }
      let!(:tag_with_42_per) { create(:registered_tag, :with_3_7_days_tweets) }
      let(:today_tweet) { create(:tweet) }
      let!(:tag_with_100_per) { today_tweet.registered_tag }
      before do
        tag_with_100_per.fetch_tweets_data!
        get '/api/v1/registered_tags/persistences'
      end
      it 'ツイートの割合が多い順に並ぶ' do
        expect(tags_json.first['id']).to eq tag_with_100_per.id
        expect(tags_json.second['id']).to eq tag_with_42_per.id
      end
      it 'ツイートがないregistered_tagを含めない' do
        expect(tags_json).to include({
          'id' => registered_tag_with_no_tweets.id,
          'tweetedDayCount' => registered_tag_with_no_tweets.tweeted_day_count,
          'privacy' => registered_tag_with_no_tweets.privacy_i18n,
          'remindDay' => nil,
          'tweetRate' => 0,
          'firstTweetedAt' => registered_tag_with_no_tweets.first_tweeted_at,
          'lastTweetedAt' => registered_tag_with_no_tweets.last_tweeted_at,
          'tag' => {
            'id' => registered_tag_with_no_tweets.tag.id,
            'name' => registered_tag_with_no_tweets.tag.name,
          },
          'user' => {
            'name' => registered_tag_with_no_tweets.user.name,
            'uuid' => registered_tag_with_no_tweets.user.uuid,
            'avatarUrl' => 'https://abs.twimg.com/sticky/default_profile_images/default_profile.png'
          }
        })
      end
    end
    describe '公開設定' do
      let!(:limited_registered_tag) { create(:registered_tag, :limited) }
      let!(:closed_registered_tag) { create(:registered_tag, :closed) }
      it '限定公開のタグを返さない' do
        expect(tags_json).not_to include 'id' => limited_registered_tag.id
        get '/api/v1/registered_tags/persistences?page=2'
        expect(tags_json).not_to include 'id' => limited_registered_tag.id
        get '/api/v1/registered_tags/persistences?page=3'
        expect(tags_json).not_to include 'id' => limited_registered_tag.id
      end
      it '非公開のタグを返さない' do
        expect(tags_json).not_to include 'id' => closed_registered_tag.id
        get '/api/v1/registered_tags/persistences?page=2'
        expect(tags_json).not_to include 'id' => closed_registered_tag.id
        get '/api/v1/registered_tags/persistences?page=3'
        expect(tags_json).not_to include 'id' => closed_registered_tag.id
      end
    end
    describe 'pagy' do
      it 'pageクエリがないとき 20件返す' do
        expect(tags_json.length).to eq 20
      end
      it 'page=2のとき 10件返す' do
        get '/api/v1/registered_tags/persistences?page=2'
        expect(tags_json.length).to eq 20
      end
    end
  end
end
