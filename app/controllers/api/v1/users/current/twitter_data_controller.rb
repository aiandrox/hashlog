class Api::V1::Users::Current::TwitterDataController < Api::V1::BaseController
  before_action :require_login

  def update
    authorize!
    TwitterAPI::User.new(current_user).call
    render json: current_user, status: :ok
  end
end
