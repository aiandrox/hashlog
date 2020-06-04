RSpec.describe 'UsersLoyalty', type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  before { login_as(user) }

  describe 'GET /api/v1/users/:uuid' do
    it '自分のデータを取得できる' do
      get "/api/v1/users/#{user.uuid}"
      expect(response.status).to eq 200
    end
    context '他人のデータの場合' do
      it '公開されている場合 取得できる' do
        other_user.published!
        get "/api/v1/users/#{other_user.uuid}"
        expect(response.status).to eq 200
      end
      it '公開されていない場合 取得できない' do
        other_user.closed!
        get "/api/v1/users/#{other_user.uuid}"
        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE /api/v1/users/:uuid' do
    context 'ゲストユーザーの場合' do
      let(:guest) { create(:user, :guest) }
      it 'ユーザーを削除できない' do
        delete "/api/v1/users/#{guest.uuid}"
        expect(response.status).to eq 403
      end
    end
  end
end
