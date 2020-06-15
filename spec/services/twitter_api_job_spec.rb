RSpec.describe TwitterAPIJob do
  let(:user) { create(:user, :real_value) }
  describe '::RemindReply' do
    let(:registered_tag) { create(:registered_tag, user: user) }
    let(:remind_reply) { TwitterAPIJob::RemindReply.new }
    before { create_list(:registered_tag, 3) }
    describe '#call' do
      it 'remind_dayが0のtagに対してsend_tweetメソッドを実行しない' do
        remind_0_tag = create(:registered_tag, remind_day: 0)
        expect(remind_reply).not_to receive(:send_tweet).with(remind_0_tag)
        remind_reply.call
      end
      it 'remind_dayが7で最終ツイートが7日前のtagに対してsend_tweetメソッドを実行しない' do
        remind_7_last_tweet_7_tag = create(:registered_tag, remind_day: 7)
        create(:tweet, :tweeted_7days_ago, registered_tag: remind_7_last_tweet_7_tag)
        expect(remind_reply).not_to receive(:send_tweet).with(remind_7_last_tweet_7_tag)
        remind_reply.call
      end
      it 'remind_dayが6で最終ツイートが7日前のtagに対してsend_tweetメソッドを実行する' do
        remind_6_last_tweet_7_tag = create(:registered_tag, remind_day: 6)
        create(:tweet, :tweeted_7days_ago, registered_tag: remind_6_last_tweet_7_tag)
        expect(remind_reply).to receive(:send_tweet).with(remind_6_last_tweet_7_tag).once
        remind_reply.call
      end
    end
  end

  describe '::AddTweets' do
    let(:registered_tag) { user.registered_tags.first }
    let(:tag) { create(:tag, name: 'ポートフォリオ進捗') }
    let(:add_tweets) { TwitterAPIJob::AddTweets.new }
    describe '#call' do
      context 'ツイートを既に取得しているとき' do
        before 'タグ登録時にツイートを取得' do
          VCR.use_cassette('twitter_api/standard_search') do
            user.register_tag(tag)
          end
        end
        context '正常系 前日のツイートを取得したとき',
          vcr: { cassette_name: 'twitter_api/everyday_search/正常系 前日のツイートを取得したとき' } do
          it '取得したツイートを保存する' do
            expect do
              add_tweets.call
            end.to change(Tweet, :count).by(3)
          end
          it 'Rails.logger.infoでログを出力する' do
            expect(Rails.logger).to receive(:info).with('@aiandrox の #ポートフォリオ進捗 にツイートを追加')
            add_tweets.call
          end
        end
        context '既に前日のツイートを取得しているとき' do
          let(:add_tweets) { TwitterAPIJob::AddTweets.new([registered_tag]) }
          it 'RegisteredTag#add_tweetsを実行しない' do
            create(:tweet, :tweeted_yesterday, registered_tag: registered_tag)
            registered_tag.fetch_tweets_data!
            expect(registered_tag).not_to receive(:add_tweets)
            add_tweets.call
          end
        end
        context '前日のツイートがなかったとき',
          vcr: { cassette_name: 'twitter_api/everyday_search/前日のツイートがなかったとき' } do
          it 'Rails.logger.infoを実行しない' do
            expect(Rails.logger).not_to receive(:info)
            add_tweets.call
          end
        end
      end
      context 'ツイートが1件も保存されていないとき',
        vcr: { cassette_name: 'twitter_api/standard_search' } do
        let!(:registered_tag) {
          create(:registered_tag, user: user, tag: create(:tag, name: 'ポートフォリオ進捗'))
        }
        let(:add_tweets) { TwitterAPIJob::AddTweets.new([registered_tag]) }
        it 'RegisteredTag#create_tweets!を実行する' do
          expect(registered_tag).to receive(:create_tweets!)
          add_tweets.call
        end
      end
    end
  end
end
