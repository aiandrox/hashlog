FactoryBot.define do
  factory :tag do
    sequence(:name, 'tag_1')
  end

  trait :invalid do
    name { '' }
  end
end
