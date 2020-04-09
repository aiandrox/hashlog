FactoryBot.define do
  factory :user do
    twitter_id { rand(10 ** 19).to_s }
    sequence(:name) { |n| "user_#{n}" }
    sequence(:screen_name) { |n| "user_#{n}" }
    after(:create) do |user|
      create_list(:tag, 3, users: [user])
    end
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
