class Api::V1::RegisteredTags::PersistencesController < Api::V1::BaseController
  def index
    registered_tags = RegisteredTag.includes(:user, :tag).opened.have_tweets
    @pagy, registered_tags = pagy(registered_tags)
    registered_tags = registered_tags.persistence_sort
    render json: registered_tags
  end
end
