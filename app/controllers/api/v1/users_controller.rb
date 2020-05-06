class Api::V1::UsersController < Api::V1::BaseController
  before_action :require_login, only: %i[current destroy]

  def index
    users = User.all
    render json: users
  end

  def show
    user = User.find_by(uuid: params[:uuid])
    render json: user
  end

  def destroy
    user = User.find_by(uuid: params[:uuid])
    if user == current_user
      user.destroy!
      render json: { message: '何を返そうか' }
    else
      head 404
    end
  end

  def current
    user = current_user
    render json: user
  end
end
