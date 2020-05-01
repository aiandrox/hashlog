RSpec.describe RegisteredTag, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:tag) }
    it { is_expected.to have_many(:tweets).dependent(:destroy) }
  end

  describe 'validations' do
    before { create(:registered_tag) }
    it { is_expected.to validate_presence_of(:tweeted_day_count) }
    it { is_expected.to validate_presence_of(:privacy) }
    it { is_expected.to validate_presence_of(:remind_day) }
    it do
      is_expected.to(validate_uniqueness_of(:tag_id)
                    .scoped_to(:user_id)
                    .with_message('を既に登録しています'))
    end
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
      let!(:latest_tag) { create(:registered_tag) }
      let!(:oldest_tag) { create(:registered_tag, :created_yesterday) }
      it 'create_atを基準に昇順に並ぶこと' do
        expect(RegisteredTag.desc.first).to eq latest_tag
        expect(RegisteredTag.desc.last).to eq oldest_tag
      end
    end
  end

  fdescribe 'methods' do
    let(:user) { create(:user, :real_value) }
    describe 'create_tweets' do
      context 'ハッシュタグのツイートが存在するとき' do
        let(:present_tag) do
          create(:registered_tag, user: user, tag: create(:tag, name: 'ポートフォリオ進捗'))
        end
        it '取得したツイートを保存する' do
          VCR.use_cassette('twitter_api/standard_search') do
            expect { present_tag.create_tweets }.to change(Tweet, :count).by(3)
          end
        end
      end
      context 'ハッシュタグのツイートが存在しないとき' do
        let(:absent_tag) do
          create(:registered_tag, user: user, tag: create(:tag, name: 'absent_tag'))
        end
        it 'ツイートを取得しないので保存しない' do
          VCR.use_cassette('twitter_api/standard_search_with_absent_tag') do
            expect { absent_tag.create_tweets }.not_to change(Tweet, :count)
          end
        end
      end
    end
    describe 'add_tweets' do
      it '保留'
    end

    describe 'fetch_data' do
      let(:registered_tag) { create(:registered_tag, :with_tweets) }
      let!(:oldest_tweet) { create(:tweet, :tweeted_7days_ago, registered_tag: registered_tag) }
      let(:latest_tweet) { registered_tag.tweets.latest }
      it 'tweet.first_tweetedが最初のツイート日時になる' do
        expect do
          registered_tag.fetch_data
        end.to change { registered_tag.first_tweeted_at }.from(nil).to(oldest_tweet.tweeted_at)
      end
      it 'tweet.last_tweetedが最後のツイート日時になる' do
        expect do
          registered_tag.fetch_data
        end.to change { registered_tag.last_tweeted_at }.from(nil).to(latest_tweet.tweeted_at)
      end
      it 'tweet.tweeted_day_countがツイートをした日数になる' do
        expect do
          registered_tag.fetch_data
        end.to change { registered_tag.tweeted_day_count }.from(0).to(2)
      end
    end
  end
end
