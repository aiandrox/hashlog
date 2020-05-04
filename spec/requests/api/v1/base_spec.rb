RSpec.describe 'Base', type: :request do
  let(:user) { create(:user) }

  describe 'rescue_limited_twitter_requests' do
    context 'TwitterAPIのリクエストが上限に達した場合' do
      let(:client) { TwitterAPI::Client.new(user, 'ハッシュタグ') }
      before do
        allow(client).to receive(:tweets_data).and_raise(Twitter::Error::TooManyRequests)
        client.tweets_data('standard')
      end
      it '429 TooManyRequestsを返す' do
        expect(response.status).to eq 429
      end
      it 'エラーメッセージのJSONを返す' do
        expect(response.body).to include 'リクエストが集中しています。15分後に再度試してください'
      end
    end
  end

  describe 'not_authenticated' do
    context 'ログインしていない場合' do
      before { get '/api/v1/mypage' }
      it '401 Unauthorizedを返す' do
        expect(response.status).to eq 401
      end
      it 'エラーメッセージのJSONを返す' do
        expect(response.body).to include 'ログインしてください'
      end
    end
  end
end
