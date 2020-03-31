RSpec.describe Authentication, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user).class_name('User') }
  end
end
