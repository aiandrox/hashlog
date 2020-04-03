describe 'RegisteredTags', type: :request do
  let(:user) { create(:user) }
  let(:tag) { user.tags.first }
  let(:registered_tag) { create(:registered_tag, user: user, tag: tag) }

  context "GET /users/:uuid/registered_tags/:id" do
    it 'ユーザーのタグページを表示する' do
      get user_registered_tag_path(user.uuid, registered_tag)
      expect(response.status).to eq 200
      expect(respense.body).to include user.name
      expect(response.body).to include tag.name
    end
  end
end
