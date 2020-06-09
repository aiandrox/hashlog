FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "tag_#{n}" }
  end

  trait :invalid do
    name { '' }
  end
end
