class UsersController < ApplicationController
  def show; end

  def edit; end

  def update; end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    redirect_to root_path, notice: 'ユーザーを削除しました'
  end
end
