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
    if (user = login_from(provider))
      user.general! # deletedになっているアカウントを有効化
      user.authentication.update!(
        access_token: access_token.token,
        access_token_secret: access_token.secret
      )
    else
      fetch_user_data_from(provider)
    end
    # ログイン判定用。JSでフラッシュメッセージが表示されたら削除する
    cookies[:logged_in] = { value: 1, expires: 3.minute.from_now }
    redirect_to mypage_dashboard_path
  end

  private

  def auth_params
    params.permit(:code, :provider, :denied)
  end

  def fetch_user_data_from(provider)
    user_from_provider = build_from(provider)
    user = User.find_or_initialize_by(twitter_id: user_from_provider.twitter_id)
    user = user_from_provider if user.new_record?
    # @user_hash, access_tokenはTwitterから受け取ったデータ
    user.build_authentication(uid: @user_hash[:uid],
                              provider: provider,
                              access_token: access_token.token,
                              access_token_secret: access_token.secret)
    user.save!
    reset_session
    auto_login(user)
  end
end
