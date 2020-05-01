FactoryBot.define do
  factory :registered_tag do
    user
    tag
  end

  trait :with_tweets do
    after(:create) do |registered_tag|
      create_list(:tweet, 3, registered_tag: registered_tag)
    end
  end

  trait :remind do
    remind_day { 3 }
  end

  trait :limited do
    privacy { :limited }
  end

  trait :closed do
    privacy { :closed }
  end

  trait :created_yesterday do
    created_at { DateTime.yesterday }
  end
end
