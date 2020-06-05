class Api::V1::UserRegisteredTagsController < Api::V1::BaseController
  # '/api/v1/users/:uuid/registered_tags'
  def index
    user = User.find_by!(uuid: params[:uuid])
    registered_tags = user.registered_tags.published.asc.includes(:tag)
    authorize!(user)
    @pagy, registered_tags = pagy(registered_tags)
    render json: registered_tags
  end
end
