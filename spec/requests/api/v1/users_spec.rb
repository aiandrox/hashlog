RSpec.describe 'Users', type: :request do
  describe 'GET /api/v1/users' do
    let(:users) { User.all }
    let(:users_json) { json['users'] }
    before do
      create_list(:user, 3)
      get '/api/v1/users'
    end
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'User.allのJSONを返す' do
      expect(users_json.length).to eq 3
      users_json.zip(users).each do |user_json, user|
        expect(user_json).to eq({
          'uuid' => user.uuid,
          'name' => user.name,
          'twitterId' => user.twitter_id,
          'screenName' => user.screen_name,
          'description' => user.description,
          'privacy' => user.privacy,
          'role' => user.role,
        })
      end
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
    it 'User.find_by(uuid: params[:uuid])のJSONを返す' do
      expect(user_json).to eq({
        'uuid' => user.uuid,
        'name' => user.name,
        'twitterId' => user.twitter_id,
        'screenName' => user.screen_name,
        'description' => user.description,
        'privacy' => user.privacy,
        'role' => user.role,
      })
    end
  end

  describe 'DELETE /api/v1/users/:uuid' do
    let!(:user) { create(:user) }
    context '自分の場合' do
      before { login_as(user) }
      it '200 OKを返す' do
        delete "/api/v1/users/#{user.uuid}"
        expect(response.status).to eq 200
      end
      it '?のJSONを返す'
      it 'Userを削除する' do
        expect do
          delete "/api/v1/users/#{user.uuid}"
        end.to change(User, :count).by(-1)
      end
    end
    context '自分以外のuserの場合' do
      let(:other_user) { create(:user) }
      before { login_as(other_user) }
      it '404 NotFoundを返す' do
        delete "/api/v1/users/#{user.uuid}"
        expect(response.status).to eq 404
      end
      it 'Userを削除しない' do
        expect do
          delete "/api/v1/users/#{user.uuid}"
        end.not_to change(User, :count)
      end
    end
    context 'ログインしていない場合' do
      it '401 Unauthorizedを返す' do
        delete "/api/v1/users/#{user.uuid}"
        expect(response.status).to eq 401
      end
      it 'Userを削除しない' do
        expect do
          delete "/api/v1/users/#{user.uuid}"
        end.not_to change(User, :count)
      end
    end
  end

  describe 'GET /api/v1/users/current' do
    let(:user) { User.all.sample }
    let(:user_json) { json['user'] }
    before { create_list(:user, 3) }
    context 'ログインしていない場合' do
      before { get '/api/v1/users/current' }
      it '401 Unauthorizedを返す' do
        expect(response.status).to eq 401
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
          'privacy' => current_user.privacy,
          'role' => current_user.role,
        })
      end
    end
  end
end
