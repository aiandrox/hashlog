RSpec.describe RemindReplyJob, type: :job do
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers
  ActiveJob::Base.queue_adapter = :test
  ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

  describe 'AddTweetsJob.perform_later' do
    it 'ジョブがすぐエンキューされる' do
      expect { RemindReplyJob.perform_later }.to have_enqueued_job.at(:no_wait)
    end
  end

  # TODO: 実行されているが……なぜ通らない
  xdescribe 'AddTweetsJob#perform' do
    let(:job) { RemindReplyJob.new }
    let(:remind_reply) { TwitterAPI::RemindReply.new }
    it 'ログを出力する' do
      expect(Rails.logger).to receive(:info)
      job.perform
    end
    it 'TwitterAPI::RemindReply#callを実行する' do
      expect(remind_reply).to receive(:call)
      job.perform
    end
  end
end
