class RegisteredTagSerializer < ActiveModel::Serializer
  attributes :id, :tweeted_day_count, :privacy, :remind_day,
             :first_tweeted_at, :last_tweeted_at, :tweet_rate
  belongs_to :tag
  # belongs_to :user, if -> { params[:count] }

  def privacy
    object.privacy_i18n
  end

  def remind_day
    object.remind_day.zero? ? nil : object.remind_day
  end
end
