RSpec.describe 'RegisteredTags', type: :request do
  describe 'GET /api/v1/users/current/registered_tags' do
    let(:user) { create(:user) }
    let!(:latest_registered_tag) { create(:registered_tag, user: user, created_at: Date.tomorrow) }
    let!(:oldest_registered_tag) { create(:registered_tag, :created_yesterday, user: user) }
    let(:registered_tags) { user.registered_tags.asc }
    let(:tags_json) { json['registeredTags'] }
    before do
      login_as(user)
      create_list(:registered_tag, 3)
      get '/api/v1/users/current/registered_tags'
    end
    # user.registered_tagsは上限3つなので、ページネーションは使わない
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'User.find(params[:uuid]).registered_tags.ascのJSONを返す' do
      expect(tags_json.length).to eq 2
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
          })
      end
    end
    it '降順に並ぶ' do
      expect(tags_json.first['id']).to eq oldest_registered_tag.id
      expect(tags_json.last['id']).to eq latest_registered_tag.id
    end
  end
end
