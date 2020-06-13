class Api::V1::OauthsController < Api::V1::BaseController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if auth_params[:denied].present?
      redirect_to root_path
      return
    end
    create_user_from(provider) unless (@user = login_from(provider))
    # ログイン判定用。JSでフラッシュメッセージが表示されたら削除する
    cookies[:logged_in] = { value: 1, expires: 3.minute.from_now }
    redirect_to mypage_dashboard_path
  end

  private

  def auth_params
    params.permit(:code, :provider, :denied)
  end

  def create_user_from(provider)
    @user = build_from(provider)
    @user.build_authentication(user_id: @user.id,
                               uid: @user_hash[:uid],
                               provider: provider,
                               access_token: @access_token.token,
                               access_token_secret: @access_token.secret)
    @user.save!
    reset_session
    auto_login(@user)
  end
end
