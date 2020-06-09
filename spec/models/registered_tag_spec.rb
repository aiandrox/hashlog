RSpec.describe RegisteredTag, type: :model do
  describe 'associations' do
    it 'belongs_to :user' do
      is_expected.to belong_to(:user)
    end
    it 'belongs_to :tag' do
      is_expected.to belong_to(:tag)
    end
    it 'has_many :tweets, destroy' do
      is_expected.to have_many(:tweets).dependent(:destroy)
    end
  end

  describe 'validations' do
    before { create(:registered_tag) }
    it 'privacy: presence' do
      is_expected.to validate_presence_of(:privacy)
    end
    it 'remind_day: numericality, only integer, <=30' do
      is_expected.to validate_numericality_of(:remind_day).only_integer.is_less_than_or_equal_to(30)
    end
    it 'tag_id: uniqueness, scoped user_id' do
      is_expected.to(validate_uniqueness_of(:tag_id)
                    .scoped_to(:user_id)
                    .with_message('は既に登録しています'))
    end
    it :user_registered_tags_count_validate do
      user = create(:user)
      create_list(:registered_tag, 3, user: user)
      registered_tag = build(:registered_tag, user: user)
      expect(registered_tag).to be_invalid
      expect(registered_tag.errors.full_messages).to include '登録できるハッシュタグは3つまでです'
    end
  end

  describe 'default value' do
    let(:registered_tag) { create(:registered_tag) }
    it 'remind_dayが0である' do
      expect(registered_tag.tweeted_day_count).to eq 0
    end
    it 'privacyがpublishedである' do
      expect(registered_tag.published?).to be_truthy
    end
  end

  describe 'scopes' do
    describe '.asc' do
      let!(:latest_tag) { create(:registered_tag) }
      let!(:oldest_tag) { create(:registered_tag, :created_yesterday) }
      it 'created_atを基準に昇順に並ぶこと' do
        expect(RegisteredTag.asc.first).to eq oldest_tag
        expect(RegisteredTag.asc.last).to eq latest_tag
      end
    end
    describe '.desc' do
      let!(:latest_tag) { create(:registered_tag) }
      let!(:oldest_tag) { create(:registered_tag, :created_yesterday) }
      it 'created_atを基準に降順に並ぶこと' do
        expect(RegisteredTag.desc.first).to eq latest_tag
        expect(RegisteredTag.desc.last).to eq oldest_tag
      end
    end
    describe '.opened' do
      let(:user) { create(:user) }
      let(:published_tag) { create(:registered_tag, user: user) }
      let(:limited_tag) { create(:registered_tag, :limited, user: user) }
      let(:closed_tag) { create(:registered_tag, :closed, user: user) }
      it '限定公開、非公開のタグを含まない' do
        expect(RegisteredTag.opened).to include published_tag
        expect(RegisteredTag.opened).not_to include limited_tag
        expect(RegisteredTag.opened).not_to include closed_tag
      end
      context 'ユーザーが非公開の場合' do
        it '公開、限定公開、非公開のタグを含まない' do
          user.closed!
          expect(RegisteredTag.opened).not_to include published_tag
          expect(RegisteredTag.opened).not_to include limited_tag
          expect(RegisteredTag.opened).not_to include closed_tag
        end
      end
    end
  end

  describe 'methods' do
    describe '#last_tweeted_at' do
      let(:registered_tag) { create(:registered_tag) }
      context 'ツイートがあるとき' do
        let!(:tweet) { create(:tweet, registered_tag: registered_tag) }
        it '最新のツイートのツイート日を返す' do
          expect(registered_tag.last_tweeted_at).to eq tweet.tweeted_at
        end
      end
      context 'ツイートがないとき' do
        it 'nilを返す' do
          expect(registered_tag.last_tweeted_at).to eq nil
        end
      end
    end

    describe '#tweeted_day_count' do
      context '計3日分のツイートがあるとき' do
        let(:registered_tag) { create(:registered_tag, :with_3_7_days_tweets) }
        it '3を返す' do
          expect(registered_tag.tweeted_day_count).to eq 3
        end
      end
      context 'ツイートがないとき' do
        let(:registered_tag) { create(:registered_tag) }
        it '0を返す' do
          expect(registered_tag.tweeted_day_count).to eq 0
        end
      end
    end

    describe '#day_from_last_tweet' do
      context '最後のツイートが7日前のとき' do
        let(:registered_tag) { create(:registered_tag) }
        before { create(:tweet, :tweeted_7days_ago, registered_tag: registered_tag) }
        it '7を返す' do
          expect(registered_tag.day_from_last_tweet).to eq 7
        end
      end
      context 'ツイートを取得していないとき' do
        let(:registered_tag) { create(:registered_tag) }
        it '0を返す' do
          expect(registered_tag.day_from_last_tweet).to eq 0
        end
      end
    end

    describe '#day_from_first_tweet' do
      context '最初のツイートが7日前のとき' do
        let(:registered_tag) { create(:registered_tag, :with_3_7_days_tweets) }
        it '8を返す（今日と最初のツイート日を含めた日数）' do
          registered_tag.fetch_tweets_data!
          expect(registered_tag.day_from_first_tweet).to eq 8
        end
      end
      context 'ツイートを取得していないとき' do
        let(:registered_tag) { create(:registered_tag) }
        it '0を返す' do
          expect(registered_tag.day_from_first_tweet).to eq 0
        end
      end
    end

    describe '#tweet_rate' do
      context '最初のツイートが7日前で計3日分のツイートがあるとき' do
        let(:registered_tag) { create(:registered_tag, :with_3_7_days_tweets) }
        it '3 / 7 * 100 = 42.9(%)を返す（小数第二位）' do
          expect(registered_tag.tweet_rate).to eq 42.9
        end
      end
      context 'ツイートを取得していないとき' do
        let(:registered_tag) { create(:registered_tag) }
        it '0を返す' do
          expect(registered_tag.tweet_rate).to eq 0
        end
      end
    end

    describe '#cron_tweets' do
      let(:user) { create(:user, :real_value) }
      let(:tag) { create(:tag, name: 'ポートフォリオ進捗') }
      let(:registered_tag) { user.registered_tag(tag) }
      before 'タグ登録時にツイートを取得' do
        VCR.use_cassette('twitter_api/standard_search') do
          user.register_tag(tag)
        end
      end

      context '正常系 前日のツイートを取得したとき',
        vcr: { cassette_name: 'twitter_api/everyday_search/正常系 前日のツイートを取得したとき' } do
        it '取得したツイートを保存する' do
          expect do
            registered_tag.cron_tweets
          end.to change(Tweet, :count).by(3)
        end
        it 'ログを出力する' do
          expect(Rails.logger).to receive(:info).with('@aiandrox の #ポートフォリオ進捗 にツイートを追加')
          registered_tag.cron_tweets
        end
      end

      context '既に前日のツイートを取得しているとき' do
        it '#add_tweetsを実行しない' do
          create(:tweet, :tweeted_yesterday, registered_tag: registered_tag)
          registered_tag.fetch_tweets_data!
          expect(registered_tag).not_to receive(:add_tweets)
          registered_tag.cron_tweets
        end
      end
      context '前日のツイートがなかったとき', vcr: { cassette_name: 'twitter_api/everyday_search/前日のツイートがなかったとき' } do
        it 'Rails.logger.infoを実行しない' do
          expect(Rails.logger).not_to receive(:info)
          registered_tag.cron_tweets
        end
      end
      context 'ツイートが1件も保存されていないとき' do
        before { registered_tag.tweets.each(&:destroy) }
        it '#create_tweets!を実行する' do
          expect(registered_tag).to receive(:create_tweets!).once
          registered_tag.cron_tweets
        end
      end
    end

    describe '#create_tweets!(type="standard")' do
      let(:user) { create(:user, :real_value) }
      context 'ハッシュタグのツイートがTwitterに存在するとき',
        vcr: { cassette_name: 'twitter_api/standard_search' } do
        let(:present_tag) do
          create(:registered_tag, user: user, tag: create(:tag, name: 'ポートフォリオ進捗'))
        end
        it '取得したツイートを保存する' do
          expect { present_tag.create_tweets! }.to change(Tweet, :count).by(3)
        end
      end
      context 'ハッシュタグのツイートがTwitterに存在しないとき',
        vcr: { cassette_name: 'twitter_api/standard_search/該当のツイートがない場合' } do
        let(:absent_tag) do
          create(:registered_tag, user: user, tag: create(:tag, name: 'absent_tag'))
        end
        it 'ツイートを取得しないので保存しない' do
          expect { absent_tag.create_tweets! }.not_to change(Tweet, :count)
        end
      end
    end

    describe '#add_tweets(since_id)' do
      let(:user) { create(:user, :real_value) }
      let(:since_id) { '1255854602626330624' }
      context 'ハッシュタグのツイートがTwitterに存在するとき',
        vcr: { cassette_name: 'twitter_api/everyday_search' } do
        let(:present_tag) do
          create(:registered_tag, user: user, tag: create(:tag, name: 'ポートフォリオ進捗'))
        end
        it '取得したツイートを保存する' do
          expect { present_tag.add_tweets(since_id) }.to change(Tweet, :count).by(1)
        end
      end
      context 'ハッシュタグのツイートがTwitterに存在しないとき',
        vcr: { cassette_name: 'twitter_api/everyday_search/該当のツイートがない場合' } do
        let(:absent_tag) do
          create(:registered_tag, user: user, tag: create(:tag, name: 'absent_tag'))
        end
        it 'ツイートを取得しないので保存しない' do
          expect { absent_tag.add_tweets(since_id) }.not_to change(Tweet, :count)
        end
      end
    end

    describe '#fetch_tweets_data!' do
      let!(:registered_tag) { create(:registered_tag, :with_tweets) }
      let!(:oldest_tweet) { create(:tweet, :tweeted_7days_ago, registered_tag: registered_tag) }
      it '更新後のtweet.first_tweetedが最初のツイート日時になる' do
        expect do
          registered_tag.fetch_tweets_data!
        end.to change { registered_tag.reload.first_tweeted_at }.to(oldest_tweet.tweeted_at)
      end
    end

    describe '#filter_remind_day' do
      context 'remind_day = nilのとき' do
        let(:registered_tag) { create(:registered_tag, remind_day: nil) }
        it 'remind_dayは0として保存される' do
          expect(registered_tag.remind_day).to eq 0
        end
      end
    end
  end
end
