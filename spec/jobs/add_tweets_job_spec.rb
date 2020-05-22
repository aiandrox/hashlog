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
  xdescribe 'AddTweetsJob#perform',
    vcr: { cassette_name: 'twitter_api/everyday_search/全てのタグのツイートを取得' } do
    let(:job) { AddTweetsJob.new }
    let(:registered_tag) { create(:registered_tag) }
    it 'ログを出力する' do
      expect(Rails.logger).to receive(:info)
      job.perform
    end
    it 'Registeredtag#cron_tweetsを実行する' do
      expect(registered_tag).to receive(:cron_tweets)
      job.perform
    end
  end
end
