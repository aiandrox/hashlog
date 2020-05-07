RSpec.describe Tweet, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:registered_tag) }
  end

  describe 'validations' do
    before { create(:registered_tag, :with_tweets) }
    it { is_expected.to validate_presence_of(:oembed) }
    it { is_expected.to validate_presence_of(:tweet_id) }
    it do
      is_expected.to(validate_uniqueness_of(:tweet_id)
                    .scoped_to(:registered_tag_id)
                    .case_insensitive)
    end
  end

  describe 'scopes' do
    let!(:latest_tweet) { create(:tweet, tweeted_at: DateTime.now) }
    let!(:oldest_tweet) { create(:tweet, tweeted_at: DateTime.yesterday) }
    describe 'desc' do
      it 'tweeted_atを基準に昇順に並ぶこと' do
        expect(Tweet.desc.first).to eq latest_tweet
        expect(Tweet.desc.last).to eq oldest_tweet
      end
    end
    describe 'tweeted_day_count' do
      before { create(:tweet, :tweeted_7days_ago)}
      it 'tweetが存在する日数を返す' do
        expect(Tweet.tweeted_day_count).to eq 3
      end
    end
  end

  describe 'methods' do
    let!(:latest_tweet) { create(:tweet) }
    let!(:oldest_tweet) { create(:tweet, :tweeted_7days_ago) }
    describe '.latest' do
      it 'tweeted_atを基準に最も新しいツイートを返す' do
        expect(Tweet.latest).to eq latest_tweet
      end
    end
    describe '.oldest' do
      it 'tweeted_atを基準に最も古いツイートを返す' do
        expect(Tweet.oldest).to eq oldest_tweet
      end
    end
  end
end
