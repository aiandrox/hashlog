describe 'UserSessions', type: :request do
  let(:user) { create(:user) }
  let!(:guest) { create(:user, :guest) }

  context 'DELETE /logout' do
    before do
      login_as(user)
    end
    it 'ログアウトする' do
      delete logout_path
      expect(response.status).to eq 302
      expect(logged_in?).to be_falsey
    end
  end

  context 'GET /guest_login' do
    it 'ゲストユーザーとしてログインする' do
      get guest_login_path
      expect(response.status).to eq 302
      expect(current_user.role).to eq 'guest'
    end
  end
end
