RSpec.describe TwitterAPI do
  let(:user) { create(:user, :real_value) }
  describe '::RemindReply' do
    let(:registered_tag) { create(:registered_tag, user: user) }
    let(:remind_reply) { TwitterAPI::RemindReply.new }
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

  # TODO: モックのテストが通らない…
  describe '::AddTweets' do
    let(:registered_tag) { user.registered_tags.first }
    let(:tag) { create(:tag, name: 'ポートフォリオ進捗') }
    let(:add_tweets) { TwitterAPI::AddTweets.new }
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
          xit 'Rails.logger.infoでログを出力する' do
            expect(Rails.logger).to receive(:info).with('@aiandrox の #ポートフォリオ進捗 にツイートを追加')
            add_tweets.call
          end
        end
        context '既に前日のツイートを取得しているとき' do
          xit 'RegisteredTag#add_tweetsを実行しない' do
            create(:tweet, :tweeted_yesterday, registered_tag: registered_tag)
            registered_tag.fetch_tweets_data!
            expect(registered_tag).not_to receive(:add_tweets)
            add_tweets.call
          end
        end
        context '前日のツイートがなかったとき',
          vcr: { cassette_name: 'twitter_api/everyday_search/前日のツイートがなかったとき' } do
          xit 'Rails.logger.infoを実行しない' do
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
        xit 'RegisteredTag#create_tweets!を実行する' do
          expect(registered_tag).to receive(:create_tweets!)
          add_tweets.call
        end
      end
    end
  end

  describe '::Search' do
    describe '#tweets_data' do
      context '該当のツイートがない場合',
        vcr: { cassette_name: 'twitter_api/standard_search/該当のツイートがない場合' } do
        let(:tag) { create(:tag, name: 'absent_tag') }
        let(:client) { TwitterAPI::Search.new(user, tag.name) }
        it '空の配列を返す' do
          expect(client.tweets_data).to eq([])
        end
      end

      context 'ツイートを取得できる場合' do
        let(:tag) { create(:tag, name: 'ポートフォリオ進捗') }
        shared_examples :return_value do
          it '配列を返す' do
            expect(
              VCR.use_cassette("twitter_api/#{type}_search") do
                client.tweets_data(type)
              end.is_a?(Array)
            ).to be_truthy
          end
          it '配列の中の要素が[tweet_oembed, tweeted_at, tweet_id]である' do
            array = VCR.use_cassette("twitter_api/#{type}_search") do
                      client.tweets_data(type)
                    end.sample
            expect(array).to(match([be_kind_of(String),
                                    be_kind_of(Time),
                                    be_kind_of(Integer)]))
          end
        end
        context '"standard"を引数に渡すとき' do
          let(:type) { 'standard' }
          let(:client) { TwitterAPI::Search.new(user, tag.name) }
          it '#standard_searchを実行する' do
            expect(client).to receive(:standard_search).once
            client.tweets_data(type)
          end
          it_behaves_like :return_value
        end
        context '"premium"を引数に渡すとき' do
          let(:type) { 'premium' }
          let(:client) { TwitterAPI::Search.new(user, tag.name) }
          it '#premiun_searchを実行する' do
            expect(client).to receive(:premium_search).once
            client.tweets_data(type)
          end
          it_behaves_like :return_value
        end
        context '"everyday"を引数に渡すとき' do
          let(:type) { 'everyday' }
          let(:since_id) { '1255854602626330624' }
          let(:client) { TwitterAPI::Search.new(user, tag.name, since_id) }
          it '#everyday_searchを実行する' do
            expect(client).to receive(:everyday_search).once
            client.tweets_data(type)
          end
          it_behaves_like :return_value
        end
      end
    end
  end
end
