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
