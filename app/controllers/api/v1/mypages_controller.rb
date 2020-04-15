class Api::V1::MypagesController < ApplicationController
  def show
    user = current_user
    tags = user.tags
    result_values = {
      user: user,
      tags: tags
    }
    render json: result_values
  end
end
