class UserSerializer < ActiveModel::Serializer
  attributes :uuid, :twitter_id, :name, :screen_name, :description, :privacy, :role

  def privacy
    object.privacy_i18n
  end

  def role
    object.role_i18n
  end
end
