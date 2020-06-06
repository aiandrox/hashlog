class Api::V1::Users::CurrentsController < Api::V1::BaseController
  before_action :require_login, only: %i[update destroy]

  def show
    user = current_user if logged_in?
    render json: user
  end

  def update
    current_user.assign_attributes(user_params)
    current_user.privacy = User.privacies_i18n.invert[params[:user][:privacy]]
    if current_user.save
      render json: current_user
    else
      error_json = {
        'code' => '422',
        'title' => '登録内容が適切ではありません',
        'detail' => '登録内容を確認してください',
        'messages' => current_user.errors.full_messages
      }
      render json: { 'error': error_json }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user
    authorize!(current_user)
    current_user.destroy!
  end

  private

  def user_params
    params.require(:user).permit(:name, :description)
  end
end
