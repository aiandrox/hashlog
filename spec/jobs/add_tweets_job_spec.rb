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

  xdescribe 'AddTweetsJob#perform' do
    let(:job) { AddTweetsJob.new }
    let(:registered_tag) { RegisteredTag.all.sample }
    before { create(:user, :with_tags) }
    it 'ログが出力される' do
      expect(Rails.logger).to receive(:info).once
      VCR.use_cassette('twitter_api/everyday_search_all_tweets', record: :new_episodes) do
        job.perform
      end
    end
    it 'RegisteredTag#add_tweetsを実行する' do
      allow_message_expectations_on_nil
      expect(registered_tag).to receive(:add_tweets)
      VCR.use_cassette('twitter_api/everyday_search_all_tweets') do
        job.perform
      end
    end
  end
end
