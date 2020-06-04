class Api::V1::RegisteredTagsLoyalty < ApplicationLoyalty
  def initialize(current_user, registered_tag)
    @current_user = current_user
    @registered_tag = registered_tag
  end

  def show?
    registered_tag.user == current_user || (registered_tag.user.published? && !registered_tag.closed?)
  end

  private

  attr_reader :current_user, :registered_tag
end

