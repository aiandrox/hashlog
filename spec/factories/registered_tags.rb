FactoryBot.define do
  factory :registered_tag do
    tweeted_day_count { 0 }
    privacy { 0 }
    remind_day { 0 }
    user
    tag
  end

  trait :remind do
    remind_day { 3 }
  end
end
