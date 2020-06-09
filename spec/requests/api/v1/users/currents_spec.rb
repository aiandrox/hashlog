RSpec.describe 'Currents', type: :request do
  describe 'GET /api/v1/users/current' do
    let(:user) { create(:user) }
    let(:user_json) { json['user'] }
    context 'ログインしていない場合' do
      before { get '/api/v1/users/current' }
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'response.bodyは"null"を返す' do
        expect(response.body).to eq "null"
      end
    end
    context 'ログインしている場合' do
      before do
        login_as(user)
        get '/api/v1/users/current'
      end
      it '200 OKを返す' do
        expect(response.status).to eq 200
      end
      it 'current_userのJSONを返す' do
        expect(user_json).to eq({
          'uuid' => current_user.uuid,
          'name' => current_user.name,
          'twitterId' => current_user.twitter_id,
          'screenName' => current_user.screen_name,
          'description' => current_user.description,
          'privacy' => current_user.privacy_i18n,
          'role' => current_user.role_i18n,
          'avatarUrl' => current_user.avatar_url,
        })
      end
    end
  end

  describe 'PATCH /api/v1/users/current' do
    let(:user) { create(:user) }
    let(:user_json) { json['user'] }
    context 'ログインしていない場合' do
      it '401 Unauthorizedを返す' do
        patch '/api/v1/users/current', params: {
          user: { description: '新しい詳細', privacy: '非公開' }
        }
        expect(response.status).to eq 401
      end
    end
    context 'ログインしている場合' do
      before { login_as(user) }
      context '正常系' do
        before do
          patch '/api/v1/users/current', params: {
            user: { description: '新しい詳細', privacy: '非公開' }
          }
        end
        it '200 OKを返す' do
          expect(response.status).to eq 200
        end
        it 'userのデータが変更される' do
          updated_user = user.reload
          expect(updated_user.description).to eq '新しい詳細'
          expect(updated_user.privacy).to eq 'closed'
        end
        it 'userのJSONを返す' do
          expect(user_json).to eq({
            'uuid' => user.uuid,
            'name' => user.name,
            'twitterId' => user.twitter_id,
            'screenName' => user.screen_name,
            'description' => '新しい詳細',
            'privacy' => '非公開',
            'role' => user.role_i18n,
            'avatarUrl' => user.avatar_url,
          } )
        end
      end
      context '値が不適な場合' do
        it '422 UnprocessableEntityを返す' do
          patch '/api/v1/users/current', params: {
            user: { description: '新しい詳細', privacy: '不適な値' }
          }
          expect(response.status).to eq 422
        end
        it 'エラーメッセージのJSONを返す' do
          patch '/api/v1/users/current', params: {
            user: { description: '新しい詳細', privacy: '不適な値' }
          }
          expect(json['error']).to eq({
            'code' => '422',
            'title' => '登録内容が適切ではありません',
            'detail' => '登録内容を確認してください',
            'messages' => ['公開設定を入力してください']
          })
        end
        it 'user.descriptionを変更しない' do
          expect do
            patch '/api/v1/users/current', params: {
              user: { description: '新しい詳細', privacy: '非公開' }
            }
          end.not_to change(user, :name)
        end
      end
    end
  end

  describe 'DELETE /api/v1/users/current' do
    let!(:user) { create(:user) }
    context 'ログインしていない場合' do
      it '401 Unauthorizedを返す' do
        delete '/api/v1/users/current'
        expect(response.status).to eq 401
      end
      it 'Userを削除しない' do
        expect do
          delete '/api/v1/users/current'
        end.not_to change(User, :count)
      end
    end
    context 'ログインしている場合' do
      before { login_as(user) }
      it '204 NoContentを返す' do
        delete '/api/v1/users/current'
        expect(response.status).to eq 204
      end
      it 'Userを削除する' do
        expect do
          delete '/api/v1/users/current'
        end.to change(User, :count).by(-1)
      end
    end
  end
end
