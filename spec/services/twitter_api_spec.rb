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
