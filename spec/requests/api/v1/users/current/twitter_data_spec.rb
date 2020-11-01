RSpec.describe 'TwitterData', type: :request do
  describe 'PATCH /api/v1/users/current/twitter_data' do
    let(:user) { create(:user) }
    let(:user_json) { json['user'] }
    context 'ログインしていない場合' do
      it '401 Unauthorizedを返す' do
        patch '/api/v1/users/current/twitter_data'
        expect(response.status).to eq 401
      end
    end
    context 'ログインしている場合', vcr: { cassette_name: 'twitter_api/user_show/hashlog' } do
      before { login_as(user) }
      context '正常系' do
        let(:user) { create(:user, twitter_id: '1048451188209770497') }
        before { patch '/api/v1/users/current/twitter_data' }
        it '200 OKを返す' do
          expect(response.status).to eq 200
        end
        it 'userのデータが変更される' do
          updated_user = user.reload
          expect(updated_user.name).to eq 'Hashlog'
          expect(updated_user.screen_name).to eq 'Hash1og'
        end
        it 'userのJSONを返す' do
          updated_user = user.reload
          expect(user_json).to eq({
            'uuid' => updated_user.uuid,
            'name' => updated_user.name,
            'twitterId' => updated_user.twitter_id,
            'screenName' => updated_user.screen_name,
            'description' => updated_user.description,
            'privacy' => updated_user.privacy_i18n,
            'role' => updated_user.role_i18n,
            'avatarUrl' => updated_user.avatar_url,
          } )
        end
      end
    end
  end
end
