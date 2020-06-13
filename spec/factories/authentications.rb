FactoryBot.define do
  factory :authentication do
    uid { rand(10 ** 19).to_s }
    provider { 'twitter' }
    user
  end
end
