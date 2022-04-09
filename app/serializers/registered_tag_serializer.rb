# == Schema Information
#
# Table name: registered_tags
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  tag_id           :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  privacy          :integer          default("published"), not null
#  remind_day       :integer          default(0), not null
#  first_tweeted_at :datetime
#
class RegisteredTagSerializer < ActiveModel::Serializer
  attributes :id, :tweeted_day_count, :privacy, :remind_day,
             :first_tweeted_at, :last_tweeted_at, :tweet_rate
  belongs_to :tag
  belongs_to :user

  def privacy
    object.privacy_i18n
  end

  def remind_day
    object.remind_day.zero? ? nil : object.remind_day
  end

  class UserSerializer < ActiveModel::Serializer
    attributes :uuid, :name, :avatar_url
  end
end
