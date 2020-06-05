RSpec.describe 'UserRegisteredTagsLoyalty', type: :request do
  let(:user) { create(:user, :with_tags) }
  let(:other_user) { create(:user, :with_tags) }
  before { login_as(user) }

  describe 'GET /api/v1/users/:uuid/registered_tags' do
    context '作成ユーザーが非公開の場合' do
      it '自分のであろうと他人のであろうとタグのデータを取得できない' do
        user.closed!
        get "/api/v1/users/#{user.uuid}/registered_tags"
        expect(response.status).to eq 403

        other_user.closed!
        get "/api/v1/users/#{other_user.uuid}/registered_tags"
        expect(response.status).to eq 403
      end
    end
    context '作成ユーザーが公開の場合' do
      it 'タグのデータを取得する' do
        user.published!
        get "/api/v1/users/#{user.uuid}/registered_tags"
        expect(response.status).to eq 200

        other_user.published!
        get "/api/v1/users/#{other_user.uuid}/registered_tags"
        expect(response.status).to eq 200
      end
    end
  end
end
