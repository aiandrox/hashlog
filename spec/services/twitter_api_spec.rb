RSpec.describe TwitterAPI::Client do
  let(:user) { create(:user, :real_value) }
  describe '#tweets_data' do
    context '該当のツイートがない場合' do
      let(:tag) { create(:tag, name: 'absent_tag') }
      let(:client) { TwitterAPI::Client.new(user, tag.name) }
      it '空の配列を返す' do
        VCR.use_cassette('twitter_api/standard_search_with_absent_tag') do
          expect(client.tweets_data).to eq([])
        end
      end
    end

    context 'ツイートを取得できる場合' do
      let(:tag) { create(:tag, name: 'ポートフォリオ進捗') }
      let(:client) { TwitterAPI::Client.new(user, tag.name) }
      let(:client_mock) { double('TwitterClient') }
      before do
        allow(client_mock).to receive(:search)
        allow(client_mock).to receive(:premium_search)
        allow(client_mock).to receive(:oembeds).and_return([])
        # メソッドを実行するかどうかだけ確かめる（TwitterAPIの返り値はどうでもいい）ときは以下のコードを記述する
        # allow(client).to receive(:client).and_return(client_mock)
      end
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
        it '#standard_searchを実行する' do
          allow(client).to receive(:client).and_return(client_mock)
          expect(client).to receive(:standard_search).once
          client.tweets_data(type)
        end
        it_behaves_like :return_value
      end
      context '"premium"を引数に渡すとき' do
        let(:type) { 'premium' }
        it '#premiun_searchを実行する' do
          allow(client).to receive(:client).and_return(client_mock)
          expect(client).to receive(:premium_search).once
          client.tweets_data(type)
        end
        it_behaves_like :return_value
      end
      context '"everyday"を引数に渡すとき' do
        let(:type) { 'everyday' }
        let(:since_id) { '1255854602626330624' }
        let(:client) { TwitterAPI::Client.new(user, tag.name, since_id) }
        it '#everyday_searchを実行する' do
          allow(client).to receive(:client).and_return(client_mock)
          expect(client).to receive(:everyday_search).once
          client.tweets_data(type)
        end
        it_behaves_like :return_value
      end
    end
  end
end