class RegisteredTagSerializer < ActiveModel::Serializer
  attributes :id, :tweeted_day_count, :privacy, :remind_day, :first_tweeted_at, :last_tweeted_at
  belongs_to :tag

  def privacy
    object.privacy_i18n
  end

  def remind_day
    if object.remind_day.zero?
      '未設定'
    else
      "#{object.remind_day}日"
    end
  end
end
