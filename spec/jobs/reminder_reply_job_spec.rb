RSpec.describe RemindReplyJob, type: :job do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers
  ActiveJob::Base.queue_adapter = :test
  ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

  describe 'RemindReplyJob.perform_later' do
    it 'ジョブがすぐエンキューされる' do
      expect { RemindReplyJob.perform_later }.to have_enqueued_job.at(:no_wait)
    end
  end

  describe 'RemindReplyJob#perform',
    vcr: { cassette_name: 'remind_reply_job Webhooks' } do
    let(:job) { RemindReplyJob.new }
    let(:remind_reply) { TwitterAPI::RemindReply.new }
    xit 'ログを出力する' do
      expect(Rails.logger).to receive(:info)
      job.perform
    end
    it 'TwitterAPI::RemindReply#callを実行する' do
      expect(remind_reply).to receive(:call)
      job.perform(remind_reply)
    end
    it 'slack_notofyが実行される' do
      expect(job).to receive(:slack_notify)
      job.perform
    end
  end
end
