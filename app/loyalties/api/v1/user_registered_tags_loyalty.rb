class Api::V1::UserRegisteredTagsLoyalty < ApplicationLoyalty
  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def index?
    user.published?
  end

  private

  attr_reader :current_user, :user
end
