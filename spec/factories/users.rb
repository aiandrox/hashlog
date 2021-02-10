FactoryBot.define do
  factory :user do
    twitter_id { rand(10 ** 19).to_s }
    sequence(:name, 'user_1')
    sequence(:screen_name, 'user_1')
    description { '' }
    after(:build) do |user|
      create(:authentication, user: user)
    end
  end

  trait :real_value do
    name { 'aiandrox' }
    screen_name { 'aiandrox' }
  end

  trait :with_tags do
    after(:build) do |user|
      create_list(:tag, 3, users: [user])
      # tagとユーザーに紐づくregistered_tagも作成される
    end
  end

  trait :admin do
    name { '管理ユーザー' }
    role { :admin }
  end
end
