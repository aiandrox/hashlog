RSpec.describe Authentication, type: :model do
  describe 'associations' do
    it 'belongs_to :user' do
      is_expected.to belong_to(:user)
    end
  end

  describe 'validations' do
    it 'uid: presence' do
      is_expected.to validate_presence_of(:uid)
    end
    it 'provider: presence' do
      is_expected.to validate_presence_of(:provider)
    end
    it 'access_token: presence' do
      is_expected.to validate_presence_of(:access_token)
    end
    it 'access_token: presence' do
      is_expected.to validate_presence_of(:access_token_secret)
    end
  end
end
