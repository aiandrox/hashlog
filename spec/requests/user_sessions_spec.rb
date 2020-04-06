describe 'UserSessions', type: :request do
  let(:user) { create(:user) }
  let(:user) { create(:user, :guest) }

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
end
