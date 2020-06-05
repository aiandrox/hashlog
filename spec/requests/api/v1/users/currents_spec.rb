RSpec.describe 'Currents', type: :request do
  describe 'GET /api/v1/users/current' do
    let(:user) { User.all.sample }
    let(:user_json) { json['user'] }
    before { create_list(:user, 3) }
    context 'ログインしていない場合' do
      before { get '/api/v1/users/current' }
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'response.bodyは"null"を返す' do
        expect(response.body).to eq "null"
      end
    end
    context 'ログインしている場合' do
      before do
        login_as(user)
        get '/api/v1/users/current'
      end
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'current_userのJSONを返す' do
        expect(user_json).to eq({
          'uuid' => current_user.uuid,
          'name' => current_user.name,
          'twitterId' => current_user.twitter_id,
          'screenName' => current_user.screen_name,
          'description' => current_user.description,
          'privacy' => current_user.privacy_i18n,
          'role' => current_user.role_i18n,
          'avatarUrl' => current_user.avatar_url,
        })
      end
    end
  end
end
