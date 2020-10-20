RSpec.describe Tweet, type: :model do
  describe 'associations' do
    it 'belongs_to registered_tag' do
      is_expected.to belong_to(:registered_tag)
    end
  end

  describe 'validations' do
    before { create(:registered_tag, :with_tweets) }
    it 'oembed: presence' do
      is_expected.to validate_presence_of(:oembed)
    end
    it 'tweet_id: presence' do
      is_expected.to validate_presence_of(:tweet_id)
    end
    it 'tweet_id: uniqueness, scoped registered_tag_id' do
      is_expected.to(validate_uniqueness_of(:tweet_id)
                    .scoped_to(:registered_tag_id)
                    .case_insensitive)
    end
    it 'tweeted_at: presence' do
      is_expected.to validate_presence_of(:tweeted_at)
    end
  end

  describe 'scopes' do
    describe '.desc' do
      let!(:latest_tweet) { create(:tweet, tweeted_at: Time.now) }
      let!(:oldest_tweet) { create(:tweet, tweeted_at: Time.now.prev_day) }
      it 'tweeted_atを基準に昇順に並ぶこと' do
        expect(Tweet.desc.first).to eq latest_tweet
        expect(Tweet.desc.last).to eq oldest_tweet
      end
    end

    describe '.tweeted_day_count' do
      it 'tweetが存在する日数を返す' do
        create_list(:tweet, 3, tweeted_at: Time.now)
        create(:tweet, tweeted_at: Time.now.prev_day)
        create(:tweet, :tweeted_7days_ago)
        expect(Tweet.tweeted_day_count).to eq 3
      end
    end

    describe '.tweeted_ats' do
      xit 'tweeted_atのみを返す' do
        create_list(:tweet, 3)
        # keyを確認したい
        expect(Tweet.tweeted_ats).not_to include 'aaa'
      end
    end

    describe '.tweeted_at_date(date)' do
      let(:the_day) { Time.parse('2020-06-01') }
      let!(:prev_day_tweet) { create(:tweet, tweeted_at: the_day.prev_day.end_of_day) }
      let!(:beginning_of_day_tweet) { create(:tweet, tweeted_at: the_day) }
      let!(:end_of_day_tweet) { create(:tweet, tweeted_at: the_day.end_of_day) }
      let!(:next_day_tweet) { create(:tweet, tweeted_at: the_day.next_day) }
      it '指定の日にツイートしたツイートを全て返す' do
        expect(Tweet.tweeted_at_date(the_day)).to include beginning_of_day_tweet
        expect(Tweet.tweeted_at_date(the_day)).to include end_of_day_tweet
      end
      it '違う日にツイートしたツイートは含まない' do
        expect(Tweet.tweeted_at_date(the_day)).not_to include prev_day_tweet
        expect(Tweet.tweeted_at_date(the_day)).not_to include next_day_tweet
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
