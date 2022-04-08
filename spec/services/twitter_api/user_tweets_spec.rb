describe TwitterApi::UserTweets do
  let(:user) { create(:user, :real_value) }
  describe '#call' do
    context '該当のツイートがない場合',
      vcr: { cassette_name: 'twitter_api/standard_search/該当のツイートがない場合' } do
      let(:tag) { create(:tag, name: 'absent_tag') }
      let(:tweets_data) { TwitterApi::UserTweets.new(user, tag.name) }
      it '空の配列を返す' do
        expect(tweets_data.call).to eq([])
      end
    end

    context 'ツイートを取得できる場合' do
      let(:tag) { create(:tag, name: 'ポートフォリオ進捗') }
      shared_examples :return_value do
        it '配列を返す' do
          expect(
            VCR.use_cassette("twitter_api/#{type}_search") do
              tweets_data.call(type)
            end.is_a?(Array)
          ).to be_truthy
        end
        it '配列の中の要素が[tweet_oembed, tweeted_at, tweet_id]である' do
          array = VCR.use_cassette("twitter_api/#{type}_search") do
                    tweets_data.call(type)
                  end.sample
          expect(array).to(match([be_kind_of(String),
                                  be_kind_of(Time),
                                  be_kind_of(Integer),
                                  be_kind_of(Array)]))
        end
      end
      context '"standard"を引数に渡すとき' do
        let(:type) { 'standard' }
        let(:tweets_data) { TwitterApi::UserTweets.new(user, tag.name) }
        it '#standard_searchを実行する' do
          expect(tweets_data).to receive(:standard_search).once
          tweets_data.call(type)
        end
        it_behaves_like :return_value
      end
      context '"premium"を引数に渡すとき' do
        let(:type) { 'premium' }
        let(:tweets_data) { TwitterApi::UserTweets.new(user, tag.name) }
        it '#premiun_searchを実行する' do
          expect(tweets_data).to receive(:premium_search).once
          tweets_data.call(type)
        end
        it_behaves_like :return_value
      end
      context '"everyday"を引数に渡すとき' do
        let(:type) { 'everyday' }
        let(:since_id) { '1255854602626330624' }
        let(:tweets_data) { TwitterApi::UserTweets.new(user, tag.name, since_id) }
        it '#everyday_searchを実行する' do
          expect(tweets_data).to receive(:everyday_search).once
          tweets_data.call(type)
        end
        it_behaves_like :return_value
      end
    end
  end
end
