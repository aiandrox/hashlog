fdescribe 'Mypages', type: :request do
  let(:user) { create(:user) }
  before { login_user(user) }
  context "GET /mypage" do
    it 'マイページを表示する' do
      get mypage_path
      expect(response.status).to eq 200
      expect(response.body).to include user.name
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
        post recruit_comments_path(recruit_a), params: FactoryBot.attributes_for(:comment, content: 'test')
      end.to change(Comment, :count).by(1)
      expect(response.status).to eq 302
      get recruit_path(recruit_a)
      expect(response.body).to include 'test'
      expect(response.body).to include "comments(#{recruit_a.comments.count})"
    end
  end

  context 'DELETE /mypage' do
    it 'current_userを削除する' do
      expect do
        delete mypage_path(user)
      end.to change(User, :count).by(-1)
      expect(response.status).to eq 302
      get root_path
    end
  end
end
