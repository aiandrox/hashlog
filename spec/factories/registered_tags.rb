FactoryBot.define do
  factory :registered_tag do
    user
    tag
    sequence(:created_at) { |n| Time.current + n.minute }

    trait :tweeted do
      first_tweeted_at { Time.parse('2020-01-01') }
      after(:build) do |registered_tag|
        create(:tweet, tweeted_at: registered_tag.first_tweeted_at, registered_tag: registered_tag)
      end
    end

    trait :with_tweets do
      transient do
        count { 3 }
      end

      after(:create) do |registered_tag, evaluator|
        create_list(:tweet, evaluator.count, registered_tag: registered_tag)
        registered_tag.fetch_tweets_data!
      end
    end

    trait :with_3_days_tweets do
      after(:create) do |registered_tag|
        create_list(:tweet, 3, :tweeted_every_day, registered_tag: registered_tag)
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
end
