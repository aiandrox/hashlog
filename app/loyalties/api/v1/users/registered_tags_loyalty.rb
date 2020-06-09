class Api::V1::Users::RegisteredTagsLoyalty < ApplicationLoyalty
  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def index?
    user == current_user || user.published?
  end

  private

  attr_reader :current_user, :user
end
