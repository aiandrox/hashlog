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
class UserSerializer < ActiveModel::Serializer
  attributes :uuid, :twitter_id, :name, :screen_name, :description, :privacy, :role, :avatar_url

  def privacy
    object.privacy_i18n
  end

  def role
    object.role_i18n
  end
end
