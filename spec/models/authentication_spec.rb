# == Schema Information
#
# Table name: authentications
#
#  id                  :bigint           not null, primary key
#  access_token        :string(255)      default(""), not null
#  access_token_secret :string(255)      default(""), not null
#  provider            :string(255)      not null
#  uid                 :string(255)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer          not null
#
# Indexes
#
#  index_authentications_on_provider_and_uid  (provider,uid)
#  index_authentications_on_user_id           (user_id)
#
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
  end
end
