describe 'Mypage::RegisteredTags', type: :request do
  let(:user) { create(:user, :with_tags) }
  let(:tag) { user.tags.first }
  let(:registered_tag) { user.registered_tags.find_by(tag_id: tag.id) }
  before { login_as(user) }

  context "GET /mypage/registered_tags/:id" do
    it 'current_userのタグページを表示する' do
      get mypage_registered_tag_path(registered_tag)
      expect(response.status).to eq 200
    end
  end

  context 'GET /mypage/registered_tags/:id/edit' do
    it '編集ページを表示する' do
      get edit_mypage_registered_tag_path(registered_tag)
      expect(response.status).to eq 200
    end
  end

  context 'PATCH /mypage/registered_tags/:id' do
    it '正しく更新される' do
      expect do
        patch mypage_registered_tag_path(registered_tag), params: { id: registered_tag.id, registered_tag: { privacy: :closed } }
      end.to change { RegisteredTag.find(registered_tag.id).privacy }.from('published').to('closed')
      expect(response.status).to eq 302
    end
  end

  context 'DELETE /mypage/registered_tags/:id' do
    it 'registered_tagを削除する' do
      expect do
        delete mypage_registered_tag_path(registered_tag)
      end.to change(RegisteredTag, :count).by(-1)
      expect(response.status).to eq 302
    end
  end
end
