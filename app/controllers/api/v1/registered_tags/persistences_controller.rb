require 'pagy/extras/array'

class Api::V1::RegisteredTags::PersistencesController < Api::V1::BaseController
  def index
    registered_tags = RegisteredTag.opened.includes(:user, :tag).persistence_sort
    @pagy, registered_tags = pagy_array(registered_tags)
    render json: registered_tags
  end
end
