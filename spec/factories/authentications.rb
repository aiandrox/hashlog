# == Schema Information
#
# Table name: authentications
#
#  id                  :bigint           not null, primary key
#  access_token        :string(255)      default(""), not null
#  access_token_secret :string(255)      default(""), not null
#  provider            :string(255)      not null
#  uid                 :string(255)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer          not null
#
# Indexes
#
#  index_authentications_on_provider_and_uid  (provider,uid)
#  index_authentications_on_user_id           (user_id)
#
FactoryBot.define do
  factory :authentication do
    uid { rand(10 ** 19).to_s }
    provider { 'twitter' }
    access_token { Rails.application.credentials[:twitter][:access_token] }
    access_token_secret { Rails.application.credentials[:twitter][:access_token_secret] }
    user
  end
end
