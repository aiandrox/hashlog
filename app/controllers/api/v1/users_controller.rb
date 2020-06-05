class Api::V1::UsersController < Api::V1::BaseController
  before_action :require_login, only: %i[update destroy]

  def index
    @pagy, users = pagy(User.published)
    render json: users
  end

  def show
    user = User.find_by!(uuid: params[:uuid])
    authorize!(user)
    render json: user
  end

  def update
    user = User.find_by!(uuid: params[:uuid])
    return head 404 unless user == current_user

    user.assign_attributes(user_params)
    user.privacy = User.privacies_i18n.invert[params[:user][:privacy]]
    if user.save
      render json: user
    else
      error_json = {
        'code' => '422',
        'title' => '登録内容が適切ではありません',
        'detail' => '登録内容を確認してください',
        'messages' => user.errors.full_messages
      }
      render json: { 'error': error_json }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by!(uuid: params[:uuid])
    authorize!(user)
    user.destroy!
  end

  def current
    user = current_user if logged_in?
    render json: user
  end

  private

  def user_params
    params.require(:user).permit(:name, :description)
  end
end
