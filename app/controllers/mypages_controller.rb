class MypagesController < ApplicationController
  before_action :set_user

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    @user.destroy!
    redirect_to root_path, notice: 'ユーザーを削除しました'
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :description, :privacy)
  end
end
