class Api::V1::UsersController < Api::V1::BaseController
  before_action :require_login, only: %i[update destroy current]

  def index
    @pagy, users = pagy(User.all)
    render json: users
  end

  def show
    user = User.find_by(uuid: params[:uuid])
    render json: user
  end

  def update
    user = User.find_by(uuid: params[:uuid])
    return head 404 unless user == current_user

    user.assign_attributes(user_params)
    user.privacy = User.privacies_i18n.invert[params[:user][:privacy]]
    if user.save
      render json: user
    else
      error_json = {
        'status' => '422',
        'title' => '登録内容が適切ではありません',
        'detail' => '登録内容を確認してください',
        'messages' => user.errors.full_messages
      }
      render json: { 'error': error_json }, status: 422
    end
  end

  def destroy
    user = User.find_by(uuid: params[:uuid])
    if user == current_user
      user.destroy!
    else
      head 404
    end
  end

  def current
    user = current_user
    render json: user
  end

  private

  def user_params
    params.require(:user).permit(:name, :description)
  end
end
