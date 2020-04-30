RSpec.describe RegisteredTag, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:tag) }
    it { is_expected.to have_many(:tweets).dependent(:destroy) }
  end

  describe 'validations' do
    before do
      build(:registered_tag)
    end
    it { is_expected.to validate_presence_of(:tweeted_day_count) }
    it { is_expected.to validate_presence_of(:privacy) }
    it { is_expected.to validate_presence_of(:remind_day) }
  end

  describe 'default value' do
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

  describe 'scopes' do
    describe 'desc' do
      it 'create_atを基準に昇順に並ぶこと'
    end
  end

  describe 'methods' do
    let(:user) { create(:user, :with_tags) }
    let(:registered_tag) { user.registered_tags.take }
    let(:tag) { registered_tag.tag }
    describe 'add_tweets' do

    end

    describe 'fetch_data' do
      let(:registered_tag) { create(:registered_tag, :with_tweets) }
      let(:oldest_tweet) { registered_tag.tweets.desc.oldest }
      let(:latest_tweet) { registered_tag.tweets.desc.latest }
      it 'tweet.first_tweetedが更新される' do
        expect do
          registered_tag.fetch_data
        end.to change { registered_tag.first_tweeted_at }.from(nil).to(oldest_tweet.tweeted_at)
      end
      it 'tweet.last_tweetedが更新される' do
        expect do
          registered_tag.fetch_data
        end.to change { registered_tag.last_tweeted_at }.from(nil).to(latest_tweet.tweeted_at)
      end
      it 'tweet.tweeted_day_countが更新される' do
        expect do
          registered_tag.fetch_data
        end.to change { registered_tag.tweeted_day_count }.from(0).to(1)
      end
    end
  end
end
