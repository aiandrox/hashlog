class Api::V1::UsersLoyalty < ApplicationLoyalty
  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def show?
    user == current_user || user.published?
  end

  private

  attr_reader :current_user, :user
end
