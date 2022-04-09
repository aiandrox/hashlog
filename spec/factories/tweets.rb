# == Schema Information
#
# Table name: tweets
#
#  id                :bigint           not null, primary key
#  oembed            :text(65535)      not null
#  tweeted_at        :datetime         not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  registered_tag_id :bigint
#  tweet_id          :string(255)      not null
#
# Indexes
#
#  index_tweets_on_registered_tag_id               (registered_tag_id)
#  index_tweets_on_tweet_id_and_registered_tag_id  (tweet_id,registered_tag_id) UNIQUE
#  index_tweets_on_tweeted_at                      (tweeted_at)
#
# Foreign Keys
#
#  fk_rails_...  (registered_tag_id => registered_tags.id)
#
FactoryBot.define do
  factory :tweet do
    sequence(:oembed, 'HTML 1')
    sequence(:tweeted_at) { |n| Time.current - n.day }
    tweet_id { rand(10 ** 19).to_s }
    registered_tag
  end

  trait :tweeted_yesterday do
    tweeted_at { Time.current.ago(1.day) }
  end

  trait :tweeted_7days_ago do
    tweeted_at { Time.current.ago(7.day) }
  end

  trait :tweeted_every_day do
    sequence(:tweeted_at) { |n| Time.current.ago(n.day) + 1.day }
  end
end
