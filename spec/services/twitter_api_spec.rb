RSpec.describe TwitterApi::Search do
  let(:user) { create(:user, :real_value) }
  describe '#tweets_data' do
    context '該当のツイートがない場合',
      vcr: { cassette_name: 'twitter_api/standard_search/該当のツイートがない場合' } do
      let(:tag) { create(:tag, name: 'absent_tag') }
      let(:client) { TwitterApi::Search.new(user, tag.name) }
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
        let(:client) { TwitterApi::Search.new(user, tag.name) }
        it '#standard_searchを実行する' do
          set_twitter_mock(user, tag.name)
          expect(client).to receive(:standard_search).once
          client.tweets_data(type)
        end
        it_behaves_like :return_value
      end
      context '"premium"を引数に渡すとき' do
        let(:type) { 'premium' }
        let(:client) { TwitterApi::Search.new(user, tag.name) }
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
        let(:client) { TwitterApi::Search.new(user, tag.name, since_id) }
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
