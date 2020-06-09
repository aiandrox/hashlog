class Api::V1::UsersController < Api::V1::BaseController
  def index
    @pagy, users = pagy(User.published)
    render json: users
  end

  def show
    user = User.find_by!(uuid: params[:uuid])
    authorize!(user)
    render json: user
  end
end
