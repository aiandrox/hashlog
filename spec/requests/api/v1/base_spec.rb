RSpec.describe 'Base', type: :request do
  let(:user) { create(:user, screen_name: 'user') }
  describe '#rescue_limited_twitter_requests' do
    context 'TwitterApiのリクエストが上限に達した場合',
      vcr: { cassette_name: 'twitter_api/standard_search/Twitter::Error::TooManyRequests' } do
      before do
        login_as(user)
        post '/api/v1/registered_tags', params: { tag: { name: 'ハッシュタグ' } }
      end
      it '429 TooManyRequestsを返す' do
        expect(response.status).to eq 429
      end
      it 'エラーメッセージのJSONを返す' do
        expect(json['error']).to eq({
          'code' => 429,
          'title' => 'Twitter APIが制限されています',
          'messages' => ['現在リクエストが集中しています。15分後に再度試してください']
        })
      end
    end
  end

  describe '#rescue_not_found' do
    context '定義されていないエンドポイントにアクセスした場合' do
      it '404 Not Foundを返す' do
        get '/api/v1/hogehoge'
        expect(response.status).to eq 404
      end
    end
    context '自分以外のユーザーのリソースにアクセスした場合' do
      let(:other_registered_tag) { create(:registered_tag) }
      before do
        login_as(user)
        patch "/api/v1/registered_tags/#{other_registered_tag.id}",
          params: { tag: { remind_day: '10' } }
      end
      it '404 Not Foundを返す' do
        expect(response.status).to eq 404
      end
      it 'エラーメッセージのJSONを返す' do
        expect(json['error']).to eq({
          'code' => 404,
          'title' => 'リソースが見つかりませんでした',
          'messages' => ['データが見つかりませんでした。アドレスを確認してください']
        })
      end
    end
  end

  describe '#not_authenticated' do
    context 'ログインしていない場合' do
      before { delete "/api/v1/users/current" }
      it '401 Unauthorizedを返す' do
        expect(response.status).to eq 401
      end
      it 'エラーメッセージのJSONを返す' do
        expect(json['error']).to eq({
          'code' => 401,
          'title' => '認証されていません',
          'messages' => ['ログインしてください']
        })
      end
    end
  end
end
