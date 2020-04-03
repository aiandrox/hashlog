describe 'Mypage::Tags', type: :request do
  let(:user) { create(:user) }
  let(:registered_tag) { user.registered_tags.first }
  before { login_as(user) }

  context 'GET /mypage/tags/new' do
    it '作成ページを表示する' do
      get new_mypage_tag_path
      expect(response.status).to eq 200
    end
  end

  context 'PATCH /mypage/registered_tags/:id' do
    it '正しく更新される' do
      expect do
        patch mypage_registered_tag_path(registered_tag), params: { registered_tag: { privacy: :closed } }
        expect(response.status).to eq 302
      end.to change { RegisteredTag.find(registered_tag.id).privacy }.from('published').to('closed')
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
