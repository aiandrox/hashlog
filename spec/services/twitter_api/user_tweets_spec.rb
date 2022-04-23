describe TwitterApi::UserTweets do
  let(:user) { create(:user) }
  describe '#call' do
    let(:tag) { create(:tag) }

    context '該当のツイートがない場合' do
      let(:tweets_data) { TwitterApi::UserTweets.new(user, tag.name) }
      before do
        client_double = double(TwitterApiClient)
        allow(TwitterApiClient).to receive(:client).and_return(client_double)
        expect(client_double).to receive(:user_timeline).with(user_id: user.twitter_id, count: 200).and_return([])
        expect(client_double).to receive(:oembeds).and_return([])
      end

      it '空の配列を返す' do
        expect(tweets_data.call).to eq([])
      end
    end

    context 'ツイートを取得できる場合' do
      context '引数にsince_idがないとき' do
        let(:tweets_data) { TwitterApi::UserTweets.new(user, tag.name) }
        before do
          tweet_id = rand(1..100)
          client_double = double(TwitterApiClient)
          tweet_instance = Twitter::Tweet.new(id: tweet_id, created_at: Time.parse('2022-01-01'))
          oembed_instance =  Twitter::OEmbed.new(
            html: "<blockquote class=\"twitter-tweet\" data-lang=\"ja\"><p lang=\"ja\" dir=\"ltr\">ここからここまで</p>&mdash; END (@aiandrox) <a href=\"https://twitter.com/aiandrox/status/1512657621118976000?ref_src=twsrc%5Etfw\">20229</a></blockquote>\n"
          )

          allow(tweet_instance).to receive(:hashtags).and_return([OpenStruct.new(text: tag.name)])
          allow(TwitterApiClient).to receive(:client).and_return(client_double)
          expect(client_double).to receive(:user_timeline).with(user_id: user.twitter_id, count: 200).and_return([tweet_instance])
          expect(client_double).to receive(:oembeds).with([tweet_id], omit_script: true, hide_thread: true, lang: :ja).and_return([oembed_instance])
        end

        it '配列の中の要素が[tweet_oembed, tweeted_at, tweet_id]である' do
          array = tweets_data.call.sample
          expect(array).to(match(['ここからここまで',
                                  be_kind_of(Time),
                                  be_kind_of(Integer),
                                  be_kind_of(Array)]))
        end
      end

      context '引数にsince_idがあるとき' do
        let(:since_id) { '1255854602626330624' }
        let(:tweets_data) { TwitterApi::UserTweets.new(user, tag.name, since_id) }
        before do
          tweet_id = rand(1..100)
          client_double = double(TwitterApiClient)
          tweet_instance = Twitter::Tweet.new(id: tweet_id, created_at: Time.parse('2022-01-01'))
          oembed_instance =  Twitter::OEmbed.new(
            html: "<blockquote class=\"twitter-tweet\" data-lang=\"ja\"><p lang=\"ja\" dir=\"ltr\">ここからここまで</p>&mdash; END (@aiandrox) <a href=\"https://twitter.com/aiandrox/status/1512657621118976000?ref_src=twsrc%5Etfw\">20229</a></blockquote>\n"
          )

          allow(tweet_instance).to receive(:hashtags).and_return([OpenStruct.new(text: tag.name)])
          allow(TwitterApiClient).to receive(:client).and_return(client_double)
          expect(client_double).to receive(:user_timeline).with(user_id: user.twitter_id, count: 200, since_id: since_id).and_return([tweet_instance])
          expect(client_double).to receive(:oembeds).with([tweet_id], omit_script: true, hide_thread: true, lang: :ja).and_return([oembed_instance])
        end

        it '配列の中の要素が[tweet_oembed, tweeted_at, tweet_id]である' do
          array = tweets_data.call.sample
          expect(array).to(match(['ここからここまで',
                                  be_kind_of(Time),
                                  be_kind_of(Integer),
                                  be_kind_of(Array)]))
        end
      end
    end
  end
end
