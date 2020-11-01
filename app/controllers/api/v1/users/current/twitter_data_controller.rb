class Api::V1::Users::Current::TwitterDataController < Api::V1::BaseController
  before_action :require_login

  def update
    authorize!
    data = TwitterAPI::User.new(current_user).call
    current_user.update!(name: data[:name],
                         screen_name: data[:screen_name],
                         avatar_url: data[:avatar_url])
    render json: current_user, status: :ok
  end
end
