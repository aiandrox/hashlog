RSpec.describe TwitterAPI do
  let(:user) { create(:user, :real_value) }
  describe '::RemindReply' do
    xdescribe '#call' do
      let(:remind_reply) { TwitterAPI::RemindReply.new }
      it '全てのregistered_tagに対してsend_tweetメソッドを実行している' do
        create_list(:registered_tag, 3)
        expect(remind_reply).not_to receive(:send_tweet).exactly(3).times
      end
      it 'remind_dayが0のtagに対してsend_tweetメソッドを実行しない' do
        remind_0_tag = create(:registered_tag, remind_day: 0)
        expect(remind_reply).not_to receive(:send_tweet).with(remind_0_tag)
        remind_reply.call
      end
      it 'remind_dayが3で最終ツイートが3日前のtagに対してsend_tweetメソッドを実行しない' do
        remind_3_last_tweet_3_tag = create(:registered_tag, remind_day: 3, last_tweeted_at: DateTime.now.ago(3.day))
        expect(remind_reply).not_to receive(:send_tweet).with(remind_3_last_tweet_3_tag)
        remind_reply.call
      end
      it 'remind_dayが2で最終ツイートが3日前のtagに対してsend_tweetメソッドを実行する' do
        remind_2_last_tweet_3_tag = create(:registered_tag, remind_day: 2, last_tweeted_at: DateTime.now.ago(3.day))
        expect(remind_reply).to receive(:send_tweet).with(remind_2_last_tweet_3_tag).once
        remind_reply.call
      end
    end

    describe '#send_reply', vcr: { cassette_name: 'twitter_api/update/リマインダー' } do
      let(:remind_reply) { TwitterAPI::RemindReply.new }
      let(:client) { remind_reply.client }
      it '#updateを実行してTwitterAPIにリクエストを送る' do
        expect(client).to receive(:update).once
        remind_reply.send_reply
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
            set_twitter_mock(user, tag.name)
            expect(client).to receive(:standard_search).once
            client.tweets_data(type)
          end
          it_behaves_like :return_value
        end
        context '"premium"を引数に渡すとき' do
          let(:type) { 'premium' }
          let(:client) { TwitterAPI::Search.new(user, tag.name) }
          it '#premiun_searchを実行する' do
            set_twitter_mock(user, tag.name)
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
            set_twitter_mock(user, tag.name, since_id)
            expect(client).to receive(:everyday_search).once
            client.tweets_data(type)
          end
          it_behaves_like :return_value
        end
      end
    end
  end
end
