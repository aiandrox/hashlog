class Api::V1::UserRegisteredTagsLoyalty < ApplicationLoyalty
  def initialize(current_user, registered_tag)
    @current_user = current_user
    @registered_tag = registered_tag
  end

  def index?
    registered_tag.nil? || registered_tag.user.published?
  end

  private

  attr_reader :current_user, :registered_tag
end
