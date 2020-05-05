class Api::V1::UsersController < Api::V1::BaseController
  before_action :require_login, only: %i[current destroy]

  def index
    users = User.all
    render json: users
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def destroy
    user = User.find(params[:id])
    user.destroy!
    render json: { message: '何を返そうか' }
  end

  def current
    user = current_user
    render json: user
  end
end
