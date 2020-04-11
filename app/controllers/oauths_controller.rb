class OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if auth_params[:denied].present?
      redirect_to root_path, notice: t('messages.cancelled_login')
      return
    end
    if (@user = login_from(provider))
      redirect_to mypage_path, notice: t('messages.logged_in')
    else
      create_user_from(provider)
    end
  end

  private

  def auth_params
    params.permit(:code, :provider, :denied)
  end

  def create_user_from(provider)
    @user = create_from(provider)
    reset_session
    auto_login(@user)
    redirect_to mypage_path, notice: t('messages.logged_in')
  rescue StandardError
    redirect_to root_path, alert: t('messages.not_logged_in'), status: 500
  end
end
