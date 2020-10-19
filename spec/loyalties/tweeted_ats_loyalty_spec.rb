RSpec.describe 'TweetedAtsLoyalty', type: :request do
  describe 'GET /api/v1/registered_tags/:id/tweeted_ats' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:my_registered_tag) { create(:registered_tag, user: user) }
    let(:other_registered_tag) { create(:registered_tag, user: other_user) }
    before { login_as(user) }
    context '自分のタグのとき' do
      subject { get "/api/v1/registered_tags/#{my_registered_tag.id}/tweeted_ats" }
      it 'ユーザーの公開設定にかかわらず取得できる' do
        user.published!
        subject
        expect(response.status).to eq 200

        user.closed!
        subject
        expect(response.status).to eq 200
      end
      it 'タグの公開設定にかかわらず取得できる' do
        my_registered_tag.published!
        subject
        expect(response.status).to eq 200

        my_registered_tag.limited!
        subject
        expect(response.status).to eq 200

        my_registered_tag.closed!
        subject
        expect(response.status).to eq 200
      end
    end
    context '他人のタグのとき' do
      context '作成ユーザーが公開のとき' do
        subject { get "/api/v1/registered_tags/#{other_registered_tag.id}/tweeted_ats" }
        it '公開/限定公開のタグを取得できる' do
          other_registered_tag.published!
          subject
          expect(response.status).to eq 200

          other_registered_tag.limited!
          subject
          expect(response.status).to eq 200
        end
        it '非公開のタグを取得できない' do
          other_registered_tag.closed!
          subject
          expect(response.status).to eq 403
        end
      end
      context '作成ユーザーが非公開のとき' do
        before { other_user.closed! }
        it 'タグの公開設定にかかわらずタグを取得できない' do
          other_registered_tag.published!
          subject
          expect(response.status).to eq 403

          other_registered_tag.limited!
          subject
          expect(response.status).to eq 403

          other_registered_tag.published!
          subject
          expect(response.status).to eq 403
        end
      end
    end
  end
end
