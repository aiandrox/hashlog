FactoryBot.define do
  factory :authentication do
    uid { rand(10 ** 19).to_s }
    provider { 'twitter' }
    access_token { Rails.application.credentials[:twitter][:access_token] }
    access_token_secret { Rails.application.credentials[:twitter][:access_token_secret] }
    user
  end
end
