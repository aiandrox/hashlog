describe Job::AddTweets do
  let(:user) { create(:user) }
  let(:tag) { create(:tag) }
  let(:registered_tag) { create(:registered_tag, user: user, tag: tag) }
  let(:add_tweets) { Job::AddTweets.new([registered_tag]) }
  describe '#call' do
    subject { add_tweets.call }
    context '過去のツイートが保存されているとき' do
      let!(:tweet) { create(:tweet, registered_tag: registered_tag) }
      context '正常系 ツイートを取得したとき' do
        before do
          double = instance_double(TwitterApi::UserTweets)
          expect(TwitterApi::UserTweets).to receive(:new).with(user, tag.name, tweet.tweet_id.to_i).and_return(double)
          allow(double).to receive(:call).and_return(
            [
              ['テキスト', Date.parse('2022-01-01'), rand(1..100), []],
              ['テキスト', Date.parse('2022-01-02'), rand(1..100), []],
              ['テキスト', Date.parse('2022-01-03'), rand(1..100), []]
            ]
          )
        end

        it '取得したツイートを保存する' do
          expect { subject }.to change(Tweet, :count).by(3)
        end
        it 'Rails.logger.infoでログを出力する' do
          logger_double = double('logger')
          allow(Rails).to receive(:logger).and_return(logger_double)
          expect(logger_double).to receive(:info).with("@#{user.screen_name} の ##{tag.name} にツイートを追加")
          subject
        end
      end

      context '取得したツイートがなかったとき' do
        before do
          double = instance_double(TwitterApi::UserTweets)
          expect(TwitterApi::UserTweets).to receive(:new).with(user, tag.name, tweet.tweet_id.to_i).and_return(double)
          allow(double).to receive(:call).and_return([])
        end

        it 'Rails.logger.infoを実行しない' do
          logger_double = double('logger')
          allow(Rails).to receive(:logger).and_return(logger_double)
          expect(logger_double).not_to receive(:info)
          subject
        end
      end
    end

    context '過去のツイートが保存されていないとき' do
      let!(:registered_tag) { create(:registered_tag, user: user, tag: tag) }
      let(:add_tweets) { Job::AddTweets.new([registered_tag]) }
      before do
        double = instance_double(TwitterApi::UserTweets)
        expect(TwitterApi::UserTweets).to receive(:new).with(user, tag.name, nil).and_return(double)
        allow(double).to receive(:call).and_return(
          [
            ['テキスト', Date.parse('2022-01-01'), rand(1..100), []],
            ['テキスト', Date.parse('2022-01-02'), rand(1..100), []],
            ['テキスト', Date.parse('2022-01-03'), rand(1..100), []]
          ]
        )
      end
      it '取得したツイートを保存する' do
        expect { subject }.to change(Tweet, :count).by(3)
      end
    end
  end
end
