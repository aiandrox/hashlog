RSpec.describe 'RegisteredTags', type: :request do
  describe 'GET /api/v1/registered_tags' do
    let!(:latest_registered_tag) { create(:registered_tag, created_at: Date.tomorrow) }
    let!(:oldest_registered_tag) { create(:registered_tag, :created_yesterday) }
    let(:registered_tags) { RegisteredTag.asc }
    before do
      create_list(:registered_tag, 3)
      get '/api/v1/registered_tags'
    end
    context '公開されている場合' do
      let(:tags_json) { json['registeredTags'] }
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'registered_tagsのJSONを返す' do
        expect(tags_json.length).to eq 5
        tags_json.zip(registered_tags).each do |tag_json, registered_tag|
          expect(tag_json).to eq({
            'id' => registered_tag.id,
            'tweetedDayCount' => registered_tag.tweeted_day_count,
            'privacy' => registered_tag.privacy,
            'remindDay' => registered_tag.remind_day,
            'firstTweetedAt' => registered_tag.first_tweeted_at,
            'lastTweetedAt' => registered_tag.last_tweeted_at,
            'tag' => {
              'id' => registered_tag.tag.id,
              'name' => registered_tag.tag.name,
              },
            })
        end
      end
      it 'registered_tagsが降順に並ぶ' do
        expect(tags_json.first['id']).to eq oldest_registered_tag.id
        expect(tags_json.last['id']).to eq latest_registered_tag.id
      end
    end
  end

  describe 'GET /api/v1/registered_tags/:id' do
    let(:registered_tag) { create(:registered_tag) }
    before { get "/api/v1/registered_tags/#{registered_tag.id}" }
    context '公開されている場合' do
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'registered_tagのJSONを返す' do
        expect(json['registeredTag']).to eq({
          'id' => registered_tag.id,
          'tweetedDayCount' => registered_tag.tweeted_day_count,
          'privacy' => registered_tag.privacy,
          'remindDay' => registered_tag.remind_day,
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
      it '403 Forbiddenを返す' do
        expect(response.status).to eq 403
      end
      it 'アクセス制限エラーのJSONレスポンスを返す' do
        p json
      end
    end
  end

  describe 'POST /api/v1/registered_tags' do
    let(:registered_tag) { create(:registered_tag) }
    before { get "/api/v1/registered_tags/#{registered_tag.id}" }
    context '適切なパラメータの場合' do
      it '201 Createdを返す' do
        expect(response.status).to eq 201
      end
      it 'registered_tagのJSONレスポンスを返す' do
        p json['registeredTag']
        # expect(response.body).to include user.name
        # expect(response.body).to include tag.name
      end
    end

    context 'タグ名が無記入の場合' do
      it '400 Bad Requestを返す' do
        expect(response.status).to eq 100
      end
      it '無記入エラーのJSONレスポンスを返す' do
        json = JSON.parse(response.body)
      end
      it 'タグを登録しない'
    end

    context '既にユーザーがそのタグを登録している場合' do
      it '400 Bad Requestを返す' do
        expect(response.status).to eq 400
      end
      it '無記入エラーのJSONレスポンスを返す' do
        json = JSON.parse(response.body)
      end
      it 'タグを登録しない'
    end

    context 'ユーザーがログインしていない場合' do
      it '401 Unauthorizedを返す' do
        expect(response.status).to eq 401
      end
      it 'ユーザを登録しない'
    end
  end
end
