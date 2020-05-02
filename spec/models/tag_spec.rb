RSpec.describe Tag, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:registered_tags).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    before { create(:tag) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
  end
end
