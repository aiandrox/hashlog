class Api::V1::TagsController < Api::V1::BaseController
  def index
    tags = Tag.all
    render json: tags
  end
end
