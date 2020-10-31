RSpec.describe TwitterAPIJob::RemindReply do
  let(:user) { create(:user, :real_value) }
  let(:registered_tag) { create(:registered_tag, user: user) }
  let(:remind_reply) { TwitterAPIJob::RemindReply.new }
  before { create_list(:registered_tag, 3) }
  describe '#call' do
    it 'remind_dayが0のtagに対してsend_tweetメソッドを実行しない' do
      remind_0_tag = create(:registered_tag, remind_day: 0)
      expect(remind_reply).not_to receive(:send_tweet).with(remind_0_tag)
      remind_reply.call
    end
    it 'remind_dayが7で最終ツイートが7日前のtagに対してsend_tweetメソッドを実行しない' do
      remind_7_last_tweet_7_tag = create(:registered_tag, remind_day: 7)
      create(:tweet, :tweeted_7days_ago, registered_tag: remind_7_last_tweet_7_tag)
      expect(remind_reply).not_to receive(:send_tweet).with(remind_7_last_tweet_7_tag)
      remind_reply.call
    end
    it 'remind_dayが6で最終ツイートが7日前のtagに対してsend_tweetメソッドを実行する' do
      remind_6_last_tweet_7_tag = create(:registered_tag, remind_day: 6)
      create(:tweet, :tweeted_7days_ago, registered_tag: remind_6_last_tweet_7_tag)
      expect(remind_reply).to receive(:send_tweet).with(remind_6_last_tweet_7_tag).once
      remind_reply.call
    end
  end
end
