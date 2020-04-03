describe 'Mypages', type: :request do
  let(:user) { create(:user) }
  let(:tag) { user.tags.first }
  before { login_as(user) }

  context "GET /mypage" do
    it 'マイページを表示する' do
      get mypage_path
      expect(response.status).to eq 200
      expect(response.body).to include user.name
      expect(response.body).to include tag.name
    end
  end

  context 'GET /mypage/edit' do
    it '編集ページを表示する' do
      get edit_mypage_path
      expect(response.status).to eq 200
    end
  end

  context 'PATCH /mypage' do
    it '正しく更新される' do
      expect do
        patch mypage_path, params: { user: { name: '変更後の名前' } }
        expect(response.status).to eq 302
      end.to change { User.find(user.id).name }.from(user.name).to('変更後の名前')
    end
  end

  context 'DELETE /mypage' do
    it 'current_userを削除する' do
      expect do
        delete mypage_path
      end.to change(User, :count).by(-1)
      expect(response.status).to eq 302
    end
  end
end
