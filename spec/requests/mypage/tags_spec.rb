describe 'Mypage::Tags', type: :request do
  let(:user) { create(:user) }
  before { login_as(user) }

  context 'GET /mypage/tags/new' do
    it '作成ページを表示する' do
      get new_mypage_tag_path
      expect(response.status).to eq 200
    end
  end

  context 'POST /mypage/tags/' do
    xit 'RegisteredTagが作成される' do
      twitter_client_mock = double('Twitter client')
      allow(twitter_client_mock).to receive(:search, :premium_search, :oembeds)
      allow(twitter_client).to receive(:twitter_client).and_return(twitter_client_mock)
      # https://qiita.com/jnchito/items/640f17e124ab263a54dd
      expect do
        post mypage_tags_path, params: { tag: { name: '今日の積み上げ' } }
        expect(response.status).to eq 302
      end.to change(RegisteredTag, :count).by(1)
    end
  end
end
