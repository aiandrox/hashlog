require 'support/vcr_helper'

describe 'Mypage::Tags', type: :request do
  let(:user) { create(:user, screen_name: 'screen_name') } # screen_nameは固定
  before { login_as(user) }

  context 'GET /mypage/tags/new' do
    it '作成ページを表示する' do
      get new_mypage_tag_path
      expect(response.status).to eq 200
    end
  end

  context 'POST /mypage/tags/', vcr: true do
    it 'RegisteredTagが作成される' do
      expect do
        post mypage_tags_path, params: { tag: { name: 'テスト' } }
        expect(response.status).to eq 302
      end.to change(RegisteredTag, :count).by(1)
    end
  end
end
