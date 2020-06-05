class Api::V1::Users::CurrentsController < Api::V1::BaseController
  def show
    user = current_user if logged_in?
    render json: user
  end
end
