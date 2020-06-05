class Api::V1::Users::RegisteredTagsController < Api::V1::BaseController
  def index
    user = User.find_by!(uuid: params[:user_uuid])
    registered_tags = user.registered_tags.published.asc.includes(:tag)
    authorize!(user)
    @pagy, registered_tags = pagy(registered_tags)
    render json: registered_tags
  end
end
