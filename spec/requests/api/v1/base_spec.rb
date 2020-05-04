RSpec.describe 'Base', type: :request do
  let(:user) { create(:user) }

  context 'rescue_limited_twitter_requests' do
    it 'TwitterAPIのリクエストが上限に達した場合 エラーメッセージを返す' do
      client = TwitterAPI::Client.new(user, 'ハッシュタグ')
      allow(client).to receive(:tweets_data).and_raise(Twitter::Error::TooManyRequests)
      client.tweets_data('standard')
      expect(response.status).to eq 429
      expect(response.body).to include 'リクエストが集中しています。15分後に再度試してください'
    end
  end

  context 'not_authenticated' do
    it 'ログインしていない場合 エラーメッセージを返す' do
      get '/api/v1/mypage'
      expect(response.status).to eq 401
      expect(response.body).to include 'ログインしてください'
    end
  end
end
