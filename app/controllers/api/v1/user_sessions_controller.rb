class Api::V1::UserSessionsController < Api::V1::BaseController
  before_action :require_login, only: :destroy

  def destroy
    logout
  end
end
