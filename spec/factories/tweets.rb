FactoryBot.define do
  factory :tweet do
    sequence(:oembed) { |n| "HTML #{n} <a href=\"https://twitter.com/hashtag/hast_#{n}?src=hash&amp;ref_src=twsrc%5Etfw\">#</a>" }
    tweeted_at { Time.now }
    tweet_id { rand(10 ** 19).to_s }
    registered_tag
  end

  trait :tweeted_yesterday do
    tweeted_at { Time.now.ago(1.day) }
  end

  trait :tweeted_7days_ago do
    tweeted_at { Time.now.ago(7.day) }
  end
end
