FactoryBot.define do
  factory :hashtag do
    sequence(:name) { |n| "hashtag_#{n}" }
  end
end
