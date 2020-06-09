class Admin::ApplicationLoyalty < ApplicationLoyalty
  def initialize(current_user)
    @current_user = current_user
  end

  def authenticate_admin?
    current_user.admin?
  end

  private

  attr_reader :current_user
end
