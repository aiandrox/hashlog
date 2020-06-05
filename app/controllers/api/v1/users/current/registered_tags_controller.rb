class Api::V1::Users::Current::RegisteredTagsController < Api::V1::BaseController
  def index
    registered_tags = current_user.registered_tags.asc.includes(:tag)
    @pagy, registered_tags = pagy(registered_tags)
    render json: registered_tags
  end
end
