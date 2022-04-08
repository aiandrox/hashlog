RSpec.describe CronTwitter do
  let(:cron) { CronTwitter.new }

  describe 'CronTwitter#call' do
    context '引数に Job::AddTweets.new を渡すとき',
      vcr: { cassette_name: 'add_tweets_job TwitterApiとWebhooks' } do
      let(:add_tweets) { Job::AddTweets.new }
      xit 'ログを出力する' do
        expect(Rails.logger).to receive(:info)
        cron.call(add_tweets)
      end
      it 'Job::AddTweets#callを実行する' do
        expect(add_tweets).to receive(:call)
        cron.call(add_tweets)
      end
      it 'slack_notofyが実行される' do
        expect(cron).to receive(:slack_notify)
        cron.call(add_tweets)
      end
    end

    context '引数に Job::RemindReply.new を渡すとき',
      vcr: { cassette_name: 'remind_reply_job Webhooks' } do
      let(:remind_reply) { Job::RemindReply.new }
      xit 'ログを出力する' do
        expect(Rails.logger).to receive(:info)
        cron.call(remind_reply)
      end
      it 'Job::AddTweets#callを実行する' do
        expect(remind_reply).to receive(:call)
        cron.call(remind_reply)
      end
      it 'slack_notofyが実行される' do
        expect(cron).to receive(:slack_notify)
        cron.call(remind_reply)
      end
    end
  end
end
