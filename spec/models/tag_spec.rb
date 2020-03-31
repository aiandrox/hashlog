RSpec.describe Tag, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:tag_users) }
    it { is_expected.to have_many(:users).through(:tag_users) }
  end

  context 'validations' do
    before do
      create(:tag)
      build(:tag)
    end
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }
  end
end
