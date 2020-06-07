RSpec.describe 'CurrentsLoyalty', type: :request do
  describe 'PATCH /api/v1/users/current' do
    let(:guest) { create(:user, :guest) }
    before { login_as(guest) }
    context 'current_userがguestの場合' do
      it '403 Forbiddenを返す' do
        patch '/api/v1/users/current', params: {
          user: { description: '新しい詳細', privacy: '非公開' }
        }
        expect(response.status).to eq 403
      end
      it 'user.descriptionを変更しない' do
        expect do
          patch '/api/v1/users/current', params: {
          user: { description: '新しい詳細', privacy: '非公開' }
        }
        end.not_to change(guest, :description)
      end
    end
  end

  describe 'DELETE /api/v1/users/current' do
    let(:guest) { create(:user, :guest) }
    before { login_as(guest) }
    context 'current_userがguestの場合' do
      it '403 Forbiddenを返す' do
        delete '/api/v1/users/current'
        expect(response.status).to eq 403
      end
      it 'Userを削除しない' do
        expect do
          delete '/api/v1/users/current'
        end.not_to change(User, :count)
      end
    end
  end
end
