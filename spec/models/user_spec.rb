RSpec.describe User, type: :model do
  context 'associations' do
  end

  context 'validations' do
    before do
      create(:user)
      build(:user)
    end
    it { is_expected.to validate_presence_of(:twitter_id) }
    it { is_expected.to validate_uniqueness_of(:twitter_id).case_insensitive }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }
    it { is_expected.to validate_length_of(:description).is_at_most(300) }
  end

  context 'default_value' do
    let(:user) { create(:user) }
    it 'privacyがpublishedである' do
      expect(user.published?).to be_truthy
    end
    it 'roleがgeneralである' do
      expect(user.general?).to be_truthy
    end
    it '9字のuuidが生成されている' do
      expect(user.uuid.length).to eq 12
    end
  end

  describe 'method' do
  end
end
