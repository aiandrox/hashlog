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
end
