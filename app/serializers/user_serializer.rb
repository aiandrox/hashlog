class UserSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :twitter_id, :name, :screen_name, :description, :privacy, :role
end
