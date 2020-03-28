FactoryBot.define do
  factory :user do
    twitter_id { '1242379749650907137' }
    sequence(:screen_name) { |n| "ユーザー#{n}" }
  end

  trait :guest do
    role { :guest }
    name { 'ゲストユーザー' }
  end

  trait :admin do
    name { '管理ユーザー' }
    role { :admin }
  end
end
