class Api::V1::CurrentRegisteredTagsController < Api::V1::BaseController
  # '/api/v1/users/current/registered_tags'
  def index
    registered_tags = current_user.registered_tags.asc.includes(:tag)
    @pagy, registered_tags = pagy(registered_tags)
    render json: registered_tags
  end
end
