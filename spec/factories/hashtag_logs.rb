FactoryBot.define do
  factory :hashtag_log do
    tweeted_day_count { 0 }
    privacy { 0 }
    remind_day { 0 }
    user
  end

  trait :remind do
    remind_day { 3 }
  end
end
