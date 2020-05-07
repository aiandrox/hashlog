RSpec.describe 'Base', type: :request do
  let(:user) { create(:user) }

  describe '#rescue_limited_twitter_requests' do
    context 'TwitterAPIのリクエストが上限に達した場合' do
      let(:client) { TwitterAPI::Client.new(user, 'ハッシュタグ') }
      before do
        allow(client).to receive(:tweets_data).and_raise(Twitter::Error::TooManyRequests)
        client.tweets_data('standard')
      end
      it '429 TooManyRequestsを返す' do
        expect(response.status).to eq 429
      end
    end
  end

  xdescribe '#rescue_not_found' do # 元々404を返す気がする
    context '定義されていないエンドポイントにアクセスした場合' do
      it '404 Not Foundを返す' do
        get '/api/v1/hogehoge'
        expect(response.status).to eq 404
      end
    end
    context '自分以外のユーザーのリソースにアクセスした場合' do
      let(:other_user) { create(:user) }
      it '404 Not Foundを返す' do
        login_as(user)
        post "/api/v1/users/#{other_user.uuid}/registered_tags", params: { tag: { name: 'hashtag' } }
        expect(response.status).to eq 404
      end
    end
  end

  describe '#not_authenticated' do
    context 'ログインしていない場合' do
      it '403 Forbiddenを返す' do
        get '/api/v1/users/current'
        expect(response.status).to eq 403
      end
    end
  end
end
