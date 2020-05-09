RSpec.describe 'RegisteredTags', type: :request do
  describe 'GET /api/v1/registered_tags' do
    let!(:latest_registered_tag) { create(:registered_tag, created_at: Date.tomorrow) }
    let!(:oldest_registered_tag) { create(:registered_tag, :created_yesterday) }
    let(:registered_tags) { RegisteredTag.asc }
    let(:tags_json) { json['registeredTags'] }
    before do
      create_list(:registered_tag, 3)
      get '/api/v1/registered_tags'
    end
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'RegisteredTag.ascのJSONを返す' do
      expect(tags_json.length).to eq 5
      tags_json.zip(registered_tags).each do |tag_json, registered_tag|
        expect(tag_json).to eq({
          'id' => registered_tag.id,
          'tweetedDayCount' => registered_tag.tweeted_day_count,
          'privacy' => registered_tag.privacy_i18n,
          'remindDay' => '未設定',
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

  describe 'GET /api/v1/users/:user_uuid/registered_tags' do
    let(:user) { create(:user, :with_tags) }
    let!(:latest_registered_tag) { create(:registered_tag, user: user, created_at: Date.tomorrow) }
    let!(:oldest_registered_tag) { create(:registered_tag, :created_yesterday, user: user) }
    let(:registered_tags) { user.registered_tags.asc }
    let(:tags_json) { json['registeredTags'] }
    before do
      create_list(:registered_tag, 3)
      get "/api/v1/users/#{user.uuid}/registered_tags"
    end
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'User.find(params[:uuid]).registered_tags.ascのJSONを返す' do # 今は全てのタグを返している
      expect(tags_json.length).to eq 5
      tags_json.zip(registered_tags).each do |tag_json, registered_tag|
        expect(tag_json).to eq({
          'id' => registered_tag.id,
          'tweetedDayCount' => registered_tag.tweeted_day_count,
          'privacy' => registered_tag.privacy_i18n,
          'remindDay' => '未設定',
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

  describe 'GET /api/v1/registered_tags/:id' do
    before { get "/api/v1/registered_tags/#{registered_tag.id}" }
    context '公開されている場合' do
      let(:registered_tag) { create(:registered_tag) }
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'RegisteredTag.find(params[:id])のJSONを返す' do
        expect(json['registeredTag']).to eq({
          'id' => registered_tag.id,
          'tweetedDayCount' => registered_tag.tweeted_day_count,
          'privacy' => registered_tag.privacy_i18n,
          'remindDay' => '未設定',
          'firstTweetedAt' => registered_tag.first_tweeted_at,
          'lastTweetedAt' => registered_tag.last_tweeted_at,
          'tag' => {
            'id' => registered_tag.tag.id,
            'name' => registered_tag.tag.name,
          }
        })
      end
    end
    xcontext '非公開の場合' do
      let(:registered_tag) { create(:registered_tag, :closed) }
      it '403 Forbiddenを返す' do
        expect(response.status).to eq 403
      end
      it 'アクセス制限エラーのJSONレスポンスを返す' do
        p json
      end
    end
  end

  describe 'POST /api/v1/registered_tags' do
    let!(:user) { create(:user, :real_value) }
    context 'ログインしている場合', vcr: { cassette_name: 'twitter_api/standard_search/該当のツイートがない場合' } do
      before { login_as(user) }
      context '正常系 タグの名前を入力したとき' do
        it '201 Createdを返す' do
          post '/api/v1/registered_tags', params: { tag: { name: 'absent_tag' } }
          expect(response.status).to eq 201
        end
        it 'registered_tag.idのJSONを返す' do
          prev_registered_tag = create(:registered_tag)
          post '/api/v1/registered_tags', params: { tag: { name: 'absent_tag' } }
          expect(json['registeredTag']).to eq({ 'id' => prev_registered_tag.id + 1 } )
        end
        it 'current_user.registered_tagsを作成する' do
          expect do
            post '/api/v1/registered_tags', params: { tag: { name: 'absent_tag' } }
          end.to change(current_user.registered_tags, :count).by(1)
        end
      end
      context 'タグの値が不適なとき' do
        it '422 UnprocessableEntityを返す' do
          post '/api/v1/registered_tags', params: { tag: { name: '' } }
          expect(response.status).to eq 422
        end
        it 'エラーメッセージのJSONを返す' do
          post '/api/v1/registered_tags', params: { tag: { name: '' } }
          expect(json['errors']).to eq([{
            'status' => '422',
            'title' => '登録内容が適切ではありません。',
            'detail' => '登録内容を確認してください。'
          }])
        end
        it 'current_user.registered_tagsを作成しない' do
          expect do
            post '/api/v1/registered_tags', params: { tag: { name: '' } }
          end.not_to change(current_user.registered_tags, :count)
        end
      end
    end
    context 'ログインしていない場合' do
      it '401 Unauthorizedを返す' do
        post '/api/v1/registered_tags', params: { tag: { name: 'hashtag_name' } }
        expect(response.status).to eq 401
      end
      it 'current_user.registered_tagsを作成しない' do
        expect do
          post '/api/v1/registered_tags', params: { tag: { name: 'hashtag_name' } }
        end.not_to change(RegisteredTag, :count)
      end
    end
  end

  describe 'DELETE /api/v1/registered_tags/:id' do
    let(:user) { create(:user) }
    let!(:registered_tag) { create(:registered_tag, user: user) }
    context '自分のregistered_tagsの場合' do
      before { login_as(user) }
      it '204 NoContentを返す' do
        delete "/api/v1/registered_tags/#{registered_tag.id}"
        expect(response.status).to eq 204
      end
      it 'user.registered_tagsを削除する' do
        expect do
          delete "/api/v1/registered_tags/#{registered_tag.id}"
        end.to change(user.registered_tags, :count).by(-1)
      end
    end
    context '自分以外のregistered_tagの場合' do
      let(:other_user) { create(:user) }
      before { login_as(other_user) }
      it '404 NotFoundを返す' do
        delete "/api/v1/registered_tags/#{registered_tag.id}"
        expect(response.status).to eq 404
      end
      it 'RegisteredTagを削除しない' do
        expect do
          delete "/api/v1/registered_tags/#{registered_tag.id}"
        end.not_to change(RegisteredTag, :count)
      end
    end
    context 'ログインしていない場合' do
      it '401 Unauthorizedを返す' do
        delete "/api/v1/registered_tags/#{registered_tag.id}"
        expect(response.status).to eq 401
      end
      it 'RegisteredTagを削除しない' do
        expect do
          delete "/api/v1/registered_tags/#{registered_tag.id}"
        end.not_to change(RegisteredTag, :count)
      end
    end
  end
end
