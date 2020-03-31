RSpec.describe HashtagLog, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:hashtag_user).dependent(:destroy) }
    it { is_expected.to have_one(:hashtag).through(:hashtag_user) }
    # it { is_expected.to have_many(:tweets).dependent(:destroy) }
  end

  context 'validations' do
    before do
      build(:hashtag_log)
    end
    it { is_expected.to validate_presence_of(:tweeted_day_count) }
    it { is_expected.to validate_presence_of(:privacy) }
    it { is_expected.to validate_presence_of(:remind_day) }
  end

  context 'default value' do
    let(:hashtag_log) { create(:hashtag_log) }
    it 'tweeted_day_countが0である' do
      expect(hashtag_log.tweeted_day_count).to eq 0
    end
    it 'remind_dayが0である' do
      expect(hashtag_log.tweeted_day_count).to eq 0
    end
    it 'privacyがpublishedである' do
      expect(hashtag_log.published?).to be_truthy
    end
  end
end
