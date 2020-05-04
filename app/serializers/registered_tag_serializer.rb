class RegisteredTagSerializer < ActiveModel::Serializer
  attributes :id, :tweeted_day_count, :privacy, :remind_day, :first_tweeted_at, :last_tweeted_at
end
