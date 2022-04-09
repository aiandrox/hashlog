# == Schema Information
#
# Table name: tweets
#
#  id                :bigint           not null, primary key
#  registered_tag_id :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  oembed            :text(65535)      not null
#  tweeted_at        :datetime         not null
#  tweet_id          :string(255)      not null
#
FactoryBot.define do
  factory :tweet do
    sequence(:oembed, 'HTML 1')
    sequence(:tweeted_at) { |n| Time.now - n.day }
    tweet_id { rand(10 ** 19).to_s }
    registered_tag
  end

  trait :tweeted_yesterday do
    tweeted_at { Time.now.ago(1.day) }
  end

  trait :tweeted_7days_ago do
    tweeted_at { Time.now.ago(7.day) }
  end

  trait :tweeted_every_day do
    sequence(:tweeted_at) { |n| Time.current.ago(n.day) + 1.day }
  end
end
