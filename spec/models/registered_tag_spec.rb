RSpec.describe RegisteredTag, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:tag) }
    # it { is_expected.to have_many(:tweets).dependent(:destroy) }
  end

  context 'validations' do
    before do
      build(:registered_tag)
    end
    it { is_expected.to validate_presence_of(:tweeted_day_count) }
    it { is_expected.to validate_presence_of(:privacy) }
    it { is_expected.to validate_presence_of(:remind_day) }
  end

  context 'default value' do
    let(:registered_tag) { create(:registered_tag) }
    it 'tweeted_day_countが0である' do
      expect(registered_tag.tweeted_day_count).to eq 0
    end
    it 'remind_dayが0である' do
      expect(registered_tag.tweeted_day_count).to eq 0
    end
    it 'privacyがpublishedである' do
      expect(registered_tag.published?).to be_truthy
    end
  end
end
