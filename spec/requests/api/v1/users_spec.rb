RSpec.describe 'Users', type: :request do
  describe 'GET /api/v1/users' do
    let(:users) { User.published }
    let(:users_json) { json['users'] }
    let!(:closed_user) { create(:user, :closed) }
    before do
      create_list(:user, 50)
      get '/api/v1/users'
    end
    describe 'pagy' do
      it 'pageクエリがないとき 10件返す' do
        expect(users_json.length).to eq 20
      end
      it 'page=2のとき 10件返す' do
        get '/api/v1/users?page=2'
        expect(users_json.length).to eq 20
      end
    end
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'User.allのJSONを返す' do
      users_json.zip(users).each do |user_json, user|
        expect(user_json).to eq({
          'uuid' => user.uuid,
          'name' => user.name,
          'twitterId' => user.twitter_id,
          'screenName' => user.screen_name,
          'description' => user.description,
          'privacy' => user.privacy_i18n,
          'role' => user.role_i18n,
          'avatarUrl' => user.avatar_url,
        })
      end
    end
    it '非公開ユーザーを返さない' do
      expect(users_json).not_to include 'uuid' => closed_user.uuid
      get '/api/v1/users?page=2'
      expect(users_json).not_to include 'uuid' => closed_user.uuid
    end
  end

  describe 'GET /api/v1/users/:uuid' do
    let(:user) { create(:user) }
    let(:user_json) { json['user'] }
    before do
      get "/api/v1/users/#{user.uuid}"
    end
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'User.find_by!(uuid: params[:uuid])のJSONを返す' do
      expect(user_json).to eq({
        'uuid' => user.uuid,
        'name' => user.name,
        'twitterId' => user.twitter_id,
        'screenName' => user.screen_name,
        'description' => user.description,
        'privacy' => user.privacy_i18n,
        'role' => user.role_i18n,
        'avatarUrl' => user.avatar_url,
      })
    end
  end
end
