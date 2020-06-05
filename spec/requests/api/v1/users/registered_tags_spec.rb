RSpec.describe 'RegisteredTags', type: :request do
  describe 'GET /api/v1/users/:uuid/registered_tags' do
    let(:user) { create(:user) }
    let(:registered_tags) { user.registered_tags.asc }
    let(:tags_json) { json['registeredTags'] }
    context 'ユーザーのタグがまだ作成されていないとき' do
      it '空の配列を返す' do
        get "/api/v1/users/#{user.uuid}/registered_tags"
        expect(tags_json).to eq []
      end
    end
    context 'ユーザーのタグが作成されているとき' do
      describe '全般のこと' do
        before do
          create_list(:registered_tag, 3, user: user)
          get "/api/v1/users/#{user.uuid}/registered_tags"
        end
        it '200 OKを返す' do
          expect(response.status).to eq 200
        end
        it 'User.find(params[:uuid]).registered_tags.ascのJSONを返す' do
          expect(tags_json.length).to eq 3
          tags_json.zip(registered_tags).each do |tag_json, registered_tag|
            expect(tag_json).to eq({
              'id' => registered_tag.id,
              'tweetedDayCount' => registered_tag.tweeted_day_count,
              'privacy' => registered_tag.privacy_i18n,
              'remindDay' => nil,
              'firstTweetedAt' => registered_tag.first_tweeted_at,
              'lastTweetedAt' => registered_tag.last_tweeted_at,
              'tag' => {
                'id' => registered_tag.tag.id,
                'name' => registered_tag.tag.name,
                },
              })
          end
        end
      end
      describe 'ソート' do
        let!(:latest_registered_tag) { create(:registered_tag, created_at: Date.tomorrow, user: user) }
        let!(:oldest_registered_tag) { create(:registered_tag, :created_yesterday, user: user) }
        it 'created_atを基準に降順に並ぶ' do
          get "/api/v1/users/#{user.uuid}/registered_tags"
          expect(tags_json.first['id']).to eq oldest_registered_tag.id
          expect(tags_json.last['id']).to eq latest_registered_tag.id
        end
      end
      describe 'データの制限' do
        let!(:limited_registered_tag) { create(:registered_tag, :limited, user: user) }
        let!(:closed_registered_tag) { create(:registered_tag, :closed, user: user) }
        it '限定公開/非公開設定のタグを含まない' do
          create(:registered_tag, user: user)
          get "/api/v1/users/#{user.uuid}/registered_tags"
          expect(tags_json.length).to eq 1
        end
      end
    end
  end
end
