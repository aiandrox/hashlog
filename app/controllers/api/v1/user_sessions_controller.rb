class Api::V1::UserSessionsController < Api::V1::BaseController
  def destroy
    logout
    render json: { flash: { type: 'success', message: 'ログアウトしました' } }
  end
end
