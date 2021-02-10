RSpec.describe 'UserSessions', type: :request do
  describe 'DELETE /api/v1/logout' do
    let(:user) { create(:user) }
    before do
      login_as(user)
      delete '/api/v1/logout'
    end
    it '204 NoContentを返す' do
      expect(response.status).to eq 204
    end
    it 'ログアウトする' do
      expect(logged_in?).to be_falsey
    end
  end
end
