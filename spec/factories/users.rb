FactoryBot.define do
  factory :user do
    twitter_id { '1242379749650907137' }
    sequence(:name) { |n| "user_#{n}" }

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
