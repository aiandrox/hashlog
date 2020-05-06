class UserSerializer < ActiveModel::Serializer
  attributes :uuid, :twitter_id, :name, :screen_name, :description, :privacy, :role
end
