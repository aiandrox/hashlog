describe 'RegisteredTags', type: :request do
  let(:user) { create(:user, :with_tags) }
  let(:tag) { user.tags.first }
  let(:registered_tag) { user.registered_tags.find_by(tag_id: tag.id) }

  fdescribe 'GET /api/v1/registered_tags/:id' do
    before { get "/api/v1/registered_tags/#{registered_tag.id}" }
    context '公開されている場合' do
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'registered_tagのJSONレスポンスを返す' do
        json = JSON.parse(response.body)
        p json
        # expect(response.body).to include user.name
        # expect(response.body).to include tag.name
      end
    end

    xcontext '非公開の場合' do
      it '403 Forbiddenを返す' do
        expect(response.status).to eq 403
      end
      it 'アクセス制限エラーのJSONレスポンスを返す' do
        json = JSON.parse(response.body)
        p json
      end
    end
  end

  describe 'POST /api/v1/registered_tags' do
    before { get "/api/v1/registered_tags/#{registered_tag.id}" }
    context '適切なパラメータの場合' do
      it '201 Createdを返す' do
        expect(response.status).to eq 201
      end
      it 'registered_tagのJSONレスポンスを返す' do
        json = JSON.parse(response.body)
        p json
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
