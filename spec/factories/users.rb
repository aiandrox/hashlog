# == Schema Information
#
# Table name: users
#
#  id          :bigint           not null, primary key
#  avatar_url  :string(255)      default("https://abs.twimg.com/sticky/default_profile_images/default_profile.png"), not null
#  description :text(65535)
#  name        :string(255)      not null
#  privacy     :integer          default("published"), not null
#  role        :integer          default("general"), not null
#  screen_name :string(255)      not null
#  uuid        :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  twitter_id  :string(255)      not null
#
# Indexes
#
#  index_users_on_twitter_id  (twitter_id) UNIQUE
#
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
