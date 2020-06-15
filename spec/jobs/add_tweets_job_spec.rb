RSpec.describe AddTweetsJob, type: :job do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers
  ActiveJob::Base.queue_adapter = :test
  ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

  describe 'AddTweetsJob.perform_later' do
    it 'ジョブがすぐエンキューされる' do
      expect { AddTweetsJob.perform_later }.to have_enqueued_job.at(:no_wait)
    end
  end

  # TODO: 実行されているが……なぜ通らない
  describe 'AddTweetsJob#perform',
    vcr: { cassette_name: 'add_tweets_job TwitterAPIとWebhooks' } do
    let(:job) { AddTweetsJob.new }
    let(:add_tweets) { TwitterAPI::AddTweets.new }
    xit 'ログを出力する' do
      expect(Rails.logger).to receive(:info)
      job.perform(add_tweets)
    end
    it 'TwitterAPI::AddTweets#callを実行する' do
      expect(add_tweets).to receive(:call)
      job.perform(add_tweets)
    end
    it 'slack_notofyが実行される' do
      expect(job).to receive(:slack_notify)
      job.perform
    end
  end
end
