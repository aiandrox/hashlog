class Api::V1::Users::Current::TwitterDataLoyalty < ApplicationLoyalty
  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def update?
    true
  end

  private

  attr_reader :current_user
end
