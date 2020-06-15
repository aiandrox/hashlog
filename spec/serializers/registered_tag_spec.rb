RSpec.describe 'RegisteredTag', type: :request do
  let(:tag_json) { json['registeredTag'] }
  describe '#remind_day' do
    context '0のとき' do
      let(:registered_tag) { create(:registered_tag, remind_day: 0) }
      it 'nilを返す' do
        get "/api/v1/registered_tags/#{registered_tag.id}"
        expect(tag_json).to eq({
          'id' => registered_tag.id,
          'tweetedDayCount' => registered_tag.tweeted_day_count,
          'privacy' => registered_tag.privacy_i18n,
          'remindDay' => nil,
          'tweetRate' => 0,
          'firstTweetedAt' => nil,
          'lastTweetedAt' => registered_tag.last_tweeted_at,
          'tag' => {
            'id' => registered_tag.tag.id,
            'name' => registered_tag.tag.name,
          },
          'user' => {
            'name' => registered_tag.user.name,
            'uuid' => registered_tag.user.uuid,
            'avatarUrl' => 'https://abs.twimg.com/sticky/default_profile_images/default_profile.png'
          }
        })
      end
    end
  end
end
