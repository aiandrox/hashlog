class Api::V1::TweetedAtsLoyalty < ApplicationLoyalty
  def initialize(current_user, registered_tag)
    @current_user = current_user
    @registered_tag = registered_tag
  end

  def index?
    registered_tag.user == current_user ||
      (registered_tag.user.published? && !registered_tag.closed?)
  end

  private

  attr_reader :current_user, :registered_tag
end
