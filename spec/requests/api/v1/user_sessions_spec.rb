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

  describe 'POST /guest_login' do
    let!(:guest) { create(:user, :guest) }
    before { post '/api/v1/guest_login' }
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'ゲストユーザーのJSONを返す' do
      expect(json['user']).to eq({
        'uuid' => guest.uuid,
        'name' => guest.name,
        'twitterId' => guest.twitter_id,
        'screenName' => guest.screen_name,
        'description' => guest.description,
        'privacy' => guest.privacy_i18n,
        'role' => 'ゲストユーザー',
        'avatarUrl' => guest.avatar_url,
      })
    end
    it 'ゲストユーザーとしてログインする' do
      expect(current_user).to eq guest
    end
  end
end
