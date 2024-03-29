class Api::V1::RegisteredTags::PersistencesController < Api::V1::BaseController
  def index
    registered_tags = RegisteredTag.includes(:user, :tag).opened.persistence_sort
    @pagy, registered_tags = pagy(registered_tags)
    render json: registered_tags
  end
end
