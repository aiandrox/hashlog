RSpec.describe 'RegisteredTagsLoyalty', type: :request do
  fdescribe 'GET /api/v1/users/:uuid/registered_tags' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:my_registered_tag) { create(:registered_tag, user: user) }
    let!(:other_registered_tag) { create(:registered_tag, user: other_user) }
    let(:tags_json) { json['registeredTag'] }
    before { login_as(user) }
    context '自分のタグのとき' do
      it 'ユーザーの公開設定にかかわらず取得できる' do
        user.published!
        get "/api/v1/users/#{user.uuid}/registered_tags"
        expect(response.status).to eq 200
        expect(tags_json.length).to eq 1

        user.closed!
        get "/api/v1/users/#{user.uuid}/registered_tags"
        expect(response.status).to eq 200
        expect(tags_json.length).to eq 1
      end
      it 'タグの公開設定にかかわらず取得できる' do
        my_registered_tag.limited!
        get "/api/v1/users/#{user.uuid}/registered_tags"
        expect(response.status).to eq 200
        expect(tags_json.length).to eq 1

        my_registered_tag.closed!
        get "/api/v1/users/#{user.uuid}/registered_tags"
        expect(response.status).to eq 200
        expect(tags_json.length).to eq 1
      end
    end
    context '他人のタグのとき' do
      context '作成ユーザーが公開のとき' do
        it '公開/限定公開のタグを取得できる' do
          other_registered_tag.published!
          get "/api/v1/users/#{other_user.uuid}/registered_tags"
          expect(response.status).to eq 200
          expect(tags_json.length).to eq 1

          other_registered_tag.limited!
          get "/api/v1/users/#{other_user.uuid}/registered_tags"
          expect(response.status).to eq 200
          expect(tags_json.length).to eq 1
        end
        it '非公開のタグを取得できない' do
          other_registered_tag.closed!
          get "/api/v1/users/#{other_user.uuid}/registered_tags"
          expect(response.status).to eq 200
          expect(tags_json.length).to eq 0
        end
      end
      context '作成ユーザーが非公開のとき' do
        before { other_user.closed! }
        it 'タグの公開設定にかかわらずタグを取得できない' do
          other_registered_tag.published!
          get "/api/v1/users/#{other_user.uuid}/registered_tags"
          expect(response.status).to eq 200
          expect(tags_json.length).to eq 0

          other_registered_tag.limited!
          get "/api/v1/users/#{other_user.uuid}/registered_tags"
          expect(response.status).to eq 200
          expect(tags_json.length).to eq 0

          other_registered_tag.published!
          get "/api/v1/users/#{other_user.uuid}/registered_tags"
          expect(response.status).to eq 200
          expect(tags_json.length).to eq 0
        end
      end
    end
  end
end
