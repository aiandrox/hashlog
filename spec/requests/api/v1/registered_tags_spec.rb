RSpec.describe 'RegisteredTags', type: :request do
  describe 'GET /api/v1/registered_tags' do
    let(:registered_tags) { RegisteredTag.opened.desc }
    let(:tags_json) { json['registeredTags'] }
    before do
      create_list(:registered_tag, 50)
      get '/api/v1/registered_tags'
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
      let!(:latest_registered_tag) { create(:registered_tag, created_at: Date.tomorrow) }
      let!(:oldest_registered_tag) { create(:registered_tag, :created_yesterday) }
      it '昇順に並ぶ（最新のregistered_tagが最初になる）' do
        get '/api/v1/registered_tags'
        expect(tags_json.first['id']).to eq latest_registered_tag.id
      end
      it '昇順に並ぶ（最古のregistered_tagが最後になる）' do
        get '/api/v1/registered_tags?page=3'
        expect(tags_json.last['id']).to eq oldest_registered_tag.id
      end
    end
    describe '公開設定' do
      let!(:limited_registered_tag) { create(:registered_tag, :limited) }
      let!(:closed_registered_tag) { create(:registered_tag, :closed) }
      it '限定公開のタグを返さない' do
        expect(tags_json).not_to include 'id' => limited_registered_tag.id
        get '/api/v1/registered_tags?page=2'
        expect(tags_json).not_to include 'id' => limited_registered_tag.id
        get '/api/v1/registered_tags?page=3'
        expect(tags_json).not_to include 'id' => limited_registered_tag.id
      end
      it '非公開のタグを返さない' do
        expect(tags_json).not_to include 'id' => closed_registered_tag.id
        get '/api/v1/registered_tags?page=2'
        expect(tags_json).not_to include 'id' => closed_registered_tag.id
        get '/api/v1/registered_tags?page=3'
        expect(tags_json).not_to include 'id' => closed_registered_tag.id
      end
    end
    context 'countクエリがないとき' do
      describe 'pagy' do
        it 'pageクエリがないとき 20件返す' do
          expect(tags_json.length).to eq 20
        end
        it 'page=2のとき 10件返す' do
          get '/api/v1/registered_tags?page=2'
          expect(tags_json.length).to eq 20
        end
      end
    end
    context 'countクエリがあるとき' do
      let(:count) { rand(1..5) }
      before do
        create_list(:registered_tag, 10)
        get "/api/v1/registered_tags?count=#{count}"
      end
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'countで指定したレコード数を返す' do
        expect(tags_json.length).to eq count
      end
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
          expect(json['error']).to eq({
            'code' => '422',
            'title' => '登録内容が適切ではありません',
            'detail' => '登録内容を確認してください',
            'messages' => ['名前を入力してください']
          })
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

  describe 'PATCH /api/v1/users/:uuid' do
    let(:user) { create(:user) }
    let(:registered_tag) { create(:registered_tag, remind_day: 1, user: user) }
    let(:registered_tag_json) { json['tag'] }
    let(:remind_day) { rand(1..30).to_s }
    context '自分の場合' do
      before { login_as(user) }
      context '正常系 remind_dayが1〜30のいずれかの数字（文字列）のとき' do
        before do
          patch "/api/v1/registered_tags/#{registered_tag.id}", params: {
            tag: { privacy: '非公開', remindDay: remind_day }
          }
        end
        it '200 OKを返す' do
          expect(response.status).to eq 200
        end
        it 'registered_tagのデータが変更される' do
          updated_registered_tag = registered_tag.reload
          expect(updated_registered_tag.privacy).to eq 'closed'
          expect(updated_registered_tag.remind_day).to eq remind_day.to_i
        end
        it 'registered_tagのJSONを返す' do
          expect(json['registeredTag']).to eq({
            'id' => registered_tag.id,
            'tweetedDayCount' => registered_tag.tweeted_day_count,
            'privacy' => '非公開',
            'remindDay' => remind_day.to_i,
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
      context 'remind_dayが"aaa"（ただの文字列）のとき' do
        let(:remind_day) { 'aaa' }
        it '422 UnprocessableEntityを返す' do
          patch "/api/v1/registered_tags/#{registered_tag.id}", params: {
            tag: { privacy: '非公開', remindDay: remind_day }
          }
          expect(response.status).to eq 422
        end
        it 'エラーメッセージのJSONを返す' do
          patch "/api/v1/registered_tags/#{registered_tag.id}", params: {
            tag: { privacy: '非公開', remindDay: remind_day }
          }
          expect(json['error']).to eq({
            'code' => '422',
            'title' => '登録内容が適切ではありません',
            'detail' => '登録内容を確認してください',
            'messages' => ['リマインダー日数は数値で入力してください']
          })
        end
        it 'registered_tag.remind_dayを変更しない' do
          expect do
            patch "/api/v1/registered_tags/#{registered_tag.id}", params: {
              tag: { privacy: '非公開', remindDay: remind_day }
            }
          end.not_to change(registered_tag, :remind_day)
        end
      end
      context 'remind_dayが31のとき' do
        let(:remind_day) { 31 }
        it '422 UnprocessableEntityを返す' do
          patch "/api/v1/registered_tags/#{registered_tag.id}", params: {
            tag: { privacy: '非公開', remindDay: remind_day }
          }
          expect(response.status).to eq 422
        end
        it 'エラーメッセージのJSONを返す' do
          patch "/api/v1/registered_tags/#{registered_tag.id}", params: {
            tag: { privacy: '非公開', remindDay: remind_day }
          }
          expect(json['error']).to eq({
            'code' => '422',
            'title' => '登録内容が適切ではありません',
            'detail' => '登録内容を確認してください',
            'messages' => ['リマインダー日数は30以下の値にしてください']
          })
        end
        it 'registered_tag.remind_dayを変更しない' do
          expect do
            patch "/api/v1/registered_tags/#{registered_tag.id}", params: {
              tag: { privacy: '非公開', remindDay: remind_day }
            }
          end.not_to change(registered_tag, :remind_day)
        end
      end
    end
    context '自分以外のregistered_tagの場合' do
      let(:other_registered_tag) { create(:registered_tag) }
      it '404 NotFoundを返す' do
        login_as(user)
        patch "/api/v1/registered_tags/#{other_registered_tag.id}", params: {
          tag: { privacy: '非公開', remindDay: remind_day }
        }
        expect(response.status).to eq 404
      end
    end
    context 'ログインしていない場合' do
      it '401 Unauthorizedを返す' do
        patch "/api/v1/registered_tags/#{registered_tag.id}", params: {
          tag: { privacy: '非公開', remindDay: remind_day }
        }
        expect(response.status).to eq 401
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
