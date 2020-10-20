class Api::V1::TweetedAtsLoyalty < ApplicationLoyalty
  def initialize(current_user, registered_tag)
    @current_user = current_user
    @registered_tag = registered_tag
  end

  def index?
    Api::V1::RegisteredTagsLoyalty.new(current_user, registered_tag).show?
  end

  private

  attr_reader :current_user, :registered_tag
end
