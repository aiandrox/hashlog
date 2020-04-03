FactoryBot.define do
  factory :user do
    twitter_id { '1242379749650907137' }
    sequence(:name) { |n| "user_#{n}" }
  end

  trait :guest do
    name { 'ゲストユーザー' }
    role { :guest }
  end

  trait :admin do
    name { '管理ユーザー' }
    role { :admin }
  end
end
