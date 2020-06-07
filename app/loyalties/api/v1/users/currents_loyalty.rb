class Api::V1::Users::CurrentsLoyalty < ApplicationLoyalty
  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def update?
    !user.guest?
  end

  def destroy?
    !user.guest?
  end

  private

  attr_reader :current_user, :user
end
