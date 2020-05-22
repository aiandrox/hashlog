FactoryBot.define do
  factory :registered_tag do
    user
    tag
  end

  trait :with_tweets do
    after(:create) do |registered_tag|
      create_list(:tweet, 3, registered_tag: registered_tag)
      registered_tag.fetch_tweets_data!
    end
  end

  # 3/7日ツイートをする
  trait :with_3_7_days_tweets do
    after(:create) do |registered_tag|
      create(:tweet, :tweeted_yesterday, registered_tag: registered_tag)
      create(:tweet, tweeted_at: Time.now.ago(3.day), registered_tag: registered_tag)
      create(:tweet, :tweeted_7days_ago, registered_tag: registered_tag)
      registered_tag.fetch_tweets_data!
    end
  end

  trait :limited do
    privacy { :limited }
  end

  trait :closed do
    privacy { :closed }
  end

  trait :created_yesterday do
    created_at { Time.now.prev_day }
  end
end
