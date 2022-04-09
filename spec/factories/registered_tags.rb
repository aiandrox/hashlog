# == Schema Information
#
# Table name: registered_tags
#
#  id               :bigint           not null, primary key
#  first_tweeted_at :datetime
#  privacy          :integer          default("published"), not null
#  remind_day       :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  tag_id           :bigint
#  user_id          :bigint
#
# Indexes
#
#  index_registered_tags_on_created_at          (created_at)
#  index_registered_tags_on_tag_id              (tag_id)
#  index_registered_tags_on_user_id             (user_id)
#  index_registered_tags_on_user_id_and_tag_id  (user_id,tag_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tag_id => tags.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :registered_tag do
    user
    tag
    sequence(:created_at) { |n| Time.current + n.minute }

    trait :tweeted do
      first_tweeted_at { Time.parse('2020-01-01') }
      after(:build) do |registered_tag|
        create(:tweet, tweeted_at: registered_tag.first_tweeted_at, registered_tag: registered_tag)
      end
    end

    trait :with_tweets do
      transient do
        count { 3 }
      end

      after(:create) do |registered_tag, evaluator|
        create_list(:tweet, evaluator.count, registered_tag: registered_tag)
        registered_tag.update!(first_tweeted_at: registered_tag.tweets.oldest.tweeted_at)
      end
    end

    trait :with_3_days_tweets do
      after(:create) do |registered_tag|
        tweets = create_list(:tweet, 3, :tweeted_every_day, registered_tag: registered_tag)
        registered_tag.update!(first_tweeted_at: registered_tag.tweets.oldest.tweeted_at)
      end
    end

    # 3/7日ツイートをする
    trait :with_3_7_days_tweets do
      after(:create) do |registered_tag|
        create(:tweet, :tweeted_yesterday, registered_tag: registered_tag)
        create(:tweet, tweeted_at: Time.current.ago(3.day), registered_tag: registered_tag)
        create(:tweet, :tweeted_7days_ago, registered_tag: registered_tag)

        registered_tag.update!(first_tweeted_at: registered_tag.tweets.oldest.tweeted_at)
      end
    end

    trait :limited do
      privacy { :limited }
    end

    trait :closed do
      privacy { :closed }
    end

    trait :created_yesterday do
      created_at { Time.current.prev_day }
    end
  end
end
