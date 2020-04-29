class Api::V1::MypagesController < Api::V1::BaseController
  before_action :require_login

  def show
    registered_tag_params = 'registered_tags.id, name, tweeted_day_count,
                             privacy, remind_day, first_tweeted_at, last_tweeted_at'
    registered_tags = current_user.registered_tags
                                  .desc
                                  .joins(:tag)
                                  .select(registered_tag_params)
    result_values = {
      user: current_user,
      registered_tags: registered_tags
    }
    render json: result_values
  end
end
