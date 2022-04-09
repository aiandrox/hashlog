# == Schema Information
#
# Table name: authentications
#
#  id                  :bigint           not null, primary key
#  user_id             :integer          not null
#  provider            :string(255)      not null
#  uid                 :string(255)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  access_token        :string(255)      default(""), not null
#  access_token_secret :string(255)      default(""), not null
#
class Authentication < ApplicationRecord
  before_save :encrypt_access_token
  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true

  def encrypt_access_token
    key_len = ActiveSupport::MessageEncryptor.key_len
    secret = Rails.application.key_generator.generate_key('salt', key_len)
    crypt = ActiveSupport::MessageEncryptor.new(secret)
    self.access_token = crypt.encrypt_and_sign(access_token)
    self.access_token_secret = crypt.encrypt_and_sign(access_token_secret)
  end
end
