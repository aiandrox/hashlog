class Api::V1::Users::RegisteredTagsController < Api::V1::BaseController
  def index
    user = User.find_by!(uuid: params[:user_uuid])
    authorize!(user)
    registered_tags = user.registered_tags.published.asc.includes(:tag)
    render json: registered_tags
  end
end
