# == Schema Information
#
# Table name: registered_tags
#
#  id               :bigint           not null, primary key
#  first_tweeted_at :datetime
#  last_tweeted_at  :datetime
#  privacy          :integer          default("published"), not null
#  remind_day       :integer          default(0), not null
#  tweet_rate       :float(24)        default(0.0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tag_id           :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_registered_tags_on_created_at          (created_at)
#  index_registered_tags_on_tag_id              (tag_id)
#  index_registered_tags_on_user_id             (user_id)
#  index_registered_tags_on_user_id_and_tag_id  (user_id,tag_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#  fk_rails_...  (user_id => users.id)
#
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
      create_list(:registered_tag, 10, user: user)
      registered_tag = build(:registered_tag, user: user)
      expect(registered_tag).to be_invalid
      expect(registered_tag.errors.full_messages).to include '登録できるハッシュタグは10個までです'
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

    describe '.have_tweets' do
      let(:registered_tag_with_tweets) { create(:registered_tag, :with_tweets) }
      let(:registered_tag_has_no_tweets) { create(:registered_tag) }
      it 'ツイートを持つregistered_tagを含む' do
        expect(RegisteredTag.have_tweets).to include registered_tag_with_tweets
      end
      it 'ツイートを持たないregistered_tagは含まない' do
        expect(RegisteredTag.have_tweets).not_to include registered_tag_has_no_tweets
      end
    end
  end

  describe 'methods' do
    describe '.day_count_sort' do
      let(:tag_with_5_tweets) { create(:registered_tag) }
      let(:tag_with_10_tweets) { create(:registered_tag) }
      before do
        create_list(:tweet, 10, registered_tag: tag_with_10_tweets)
        create_list(:tweet, 5, registered_tag: tag_with_5_tweets)
      end
      specify do
        expect(RegisteredTag.day_count_sort.first).to eq tag_with_10_tweets
      end
      specify do
        expect(RegisteredTag.day_count_sort.last).to eq tag_with_5_tweets
      end
      specify do
        expect(RegisteredTag.day_count_sort).to be_a Array
      end
    end

    describe '.persistence_sort' do
      let!(:tag_with_3_days_tweets) { create(:registered_tag) }
      let!(:tag_with_1_day_tweet) { create(:registered_tag) }
      let!(:tag_with_0_day) { create(:registered_tag) }
      before do
        now = Time.current
        create(:tweet, tweeted_at: now, registered_tag: tag_with_3_days_tweets)
        create(:tweet, tweeted_at: now.yesterday, registered_tag: tag_with_3_days_tweets)
        create(:tweet, tweeted_at: now.tomorrow, registered_tag: tag_with_3_days_tweets)
        create(:tweet, tweeted_at: now, registered_tag: tag_with_1_day_tweet)
      end
      it 'ツイート日数が3日のタグが最初になる' do
        expect(RegisteredTag.persistence_sort[0]).to eq tag_with_3_days_tweets
      end
      it 'ツイート日数が1日のタグが二番目になる' do
        expect(RegisteredTag.persistence_sort[1]).to eq tag_with_1_day_tweet
      end
      it 'tweet_rate0%のタグが最後になる' do
        expect(RegisteredTag.persistence_sort[-1]).to eq tag_with_0_day
      end
      specify do
        expect(RegisteredTag.persistence_sort).to be_a Array
      end
    end

    describe '.tweet_rate' do
      subject { RegisteredTag.tweet_rate(registered_tag) }

      context 'ツイートを取得していないとき' do
        let(:registered_tag) { create(:registered_tag) }
        it '0(%)を返す' do
          expect(subject).to eq 0
        end
      end

      context '最初のツイートと最後のツイートが今日のとき' do
        let(:registered_tag) { create(:registered_tag) }
        it '100(%)を返す' do
          create(:tweet, registered_tag: registered_tag, tweeted_at: Time.current)
          expect(subject).to eq 100
        end
      end

      context '最初のツイートが7日前で計3日分のツイートがあるとき（今日含まず）' do
        let(:registered_tag) { create(:registered_tag, :with_3_7_days_tweets) }
        it '3 / 7 * 100 = 42.9(%)を返す（小数第一位）' do
          expect(subject).to eq 42.9
        end
      end

      context '最初のツイートが7日前で計4日分のツイートがあるとき（今日含む）' do
        let(:registered_tag) { create(:registered_tag, :with_3_7_days_tweets) }
        it '4 / 8 * 100 = 50.0(%)を返す' do
          create(:tweet, registered_tag: registered_tag, tweeted_at: Time.current)
          expect(subject).to eq 50.0
        end
      end
    end

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

    describe '#remind_reply?' do
      subject { registered_tag.remind_reply? }
      context 'remind_dayが0のとき' do
        let(:registered_tag) { build(:registered_tag, remind_day: 0) }
        it { is_expected.to eq false }
      end
      context 'remind_dayが5のとき' do
        let(:registered_tag) { build(:registered_tag, remind_day: 5) }
        context '最後のツイートが5日前のとき' do
          before { create(:tweet, tweeted_at: Time.zone.today.ago(5.days), registered_tag: registered_tag) }
          it { is_expected.to eq false }
        end
        context '最後のツイートが6日前のとき' do
          before { create(:tweet, tweeted_at: Time.zone.today.ago(6.days), registered_tag: registered_tag) }
          it { is_expected.to eq true }
        end
        context '最後のツイートが9日前のとき' do
          before { create(:tweet, tweeted_at: Time.zone.today.ago(9.days), registered_tag: registered_tag) }
          it { is_expected.to eq true }
        end
        context '最後のツイートが10日前のとき' do
          before { create(:tweet, tweeted_at: Time.zone.today.ago(10.days), registered_tag: registered_tag) }
          it { is_expected.to eq false }
        end
      end
    end

    describe '#create_tweets(tweet_data_array)' do
      let(:registered_tag) { create(:registered_tag) }
      subject { registered_tag.create_tweets(tweet_data_array) }
      context 'ハッシュタグのツイートがTwitterに存在するとき' do
        let(:tweet_data_array) { [['text', Date.current, '1255854602626330624', []]] }
        it '取得したツイートを保存する' do
          expect { subject }.to change(Tweet, :count).by(1)
        end
        it '更新後のtweet.first_tweetedが最初のツイート日時になる' do
          subject
          expect(registered_tag.reload.first_tweeted_at).to eq Tweet.last.tweeted_at
        end
      end
      context 'ハッシュタグのツイートがTwitterに存在しないとき' do
        let(:tweet_data_array) { [] }
        it 'ツイートを取得しないので保存しない' do
          expect { subject }.not_to change(Tweet, :count)
        end
        it '最初のツイート日時はnilのまま' do
          subject
          expect(registered_tag.reload.first_tweeted_at).to eq nil
        end
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
