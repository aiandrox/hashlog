describe Job::AddTweets do
  let(:user) { create(:user, :real_value) }
  let(:registered_tag) { user.registered_tags.first }
  let(:tag) { create(:tag, name: 'ポートフォリオ進捗') }
  let(:add_tweets) { Job::AddTweets.new }
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
        let(:add_tweets) { Job::AddTweets.new([registered_tag]) }
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
      let(:add_tweets) { Job::AddTweets.new([registered_tag]) }
      it 'RegisteredTag#create_tweetsを実行する' do
        expect(registered_tag).to receive(:create_tweets)
        add_tweets.call
      end
    end
  end
end
