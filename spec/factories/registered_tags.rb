FactoryBot.define do
  factory :registered_tag do
    user
    tag
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
end
