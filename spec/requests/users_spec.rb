describe 'Users', type: :request do
  let(:user) { create(:user) }
  let(:tag) { user.tags.first }

  context 'GET /users/:uuid' do
    it 'ユーザーページを表示する' do
      get user_path(user.uuid)
      expect(response.status).to eq 200
      expect(response.body).to include user.name
      expect(response.body).to include tag.name
    end
  end
end
