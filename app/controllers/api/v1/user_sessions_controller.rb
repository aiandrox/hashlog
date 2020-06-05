class Api::V1::UserSessionsController < Api::V1::BaseController
  before_action :require_login, only: :destroy

  def destroy
    logout
  end

  def guest_login
    user = User.find_by!(role: :guest)
    auto_login(user)
    render json: user, status: 200
  end
end
