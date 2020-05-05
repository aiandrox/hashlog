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
          'id' => user.id,
          'name' => user.name,
          'uuid'=> user.uuid,
          'twitterId'=> user.twitter_id,
          'screenName'=> user.screen_name,
          'description'=> user.description,
          'privacy'=> user.privacy,
          'role'=> user.role,
        })
      end
    end
  end

  describe 'GET /api/v1/users/:id' do
    let(:user) { create(:user) }
    let(:user_json) { json['user'] }
    before do
      get "/api/v1/users/#{user.id}"
    end
    it '200 OKを返す' do
      expect(response.status).to eq 200
    end
    it 'User.find(params[:id])のJSONを返す' do
      expect(user_json).to eq({
        'id' => user.id,
        'name' => user.name,
        'uuid'=> user.uuid,
        'twitterId'=> user.twitter_id,
        'screenName'=> user.screen_name,
        'description'=> user.description,
        'privacy'=> user.privacy,
        'role'=> user.role,
      })
    end
  end

  describe 'GET /api/v1/users/:id' do
    xit '200 OK？を返す' do
      expect(response.status).to eq 200
    end
    it 'JSONを返す'
    it 'ユーザーを削除する'
  end

  describe 'GET /api/v1/users/current' do
    let(:user) { User.all.sample }
    let(:user_json) { json['user'] }
    before { create_list(:user, 3) }
    context 'ログインしていない場合' do
      before { get '/api/v1/users/current' }
      it 'require_login'
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
          'id' => current_user.id,
          'name' => current_user.name,
          'uuid'=> current_user.uuid,
          'twitterId'=> current_user.twitter_id,
          'screenName'=> current_user.screen_name,
          'description'=> current_user.description,
          'privacy'=> current_user.privacy,
          'role'=> current_user.role,
        })
      end
    end
  end
end
