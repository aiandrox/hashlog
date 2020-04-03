class Mypage::TagsController < Mypage::BaseController
  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.find_or_initialize_by(tag_params)
    if create_registered_tag(@tag)
      redirect_to mypage_path, notice: "#{@tag.name}を登録しました"
    else
      flash.now[:alert] = '登録できませんでした'
      render :new
    end
  end

  private

  def create_registered_tag(tag)
    ActiveRecord::Base.transaction do
      tag.save!
      registered_tag = current_user.registered_tags.build(tag_id: tag.id)
      registered_tag.save!
    rescue ActiveRecord::RecordInvalid
      if registered_tag&.invalid?
        tag.errors.messages.merge!(registered_tag.errors.messages)
      end
      false
    rescue StandardError
      render status: 500
    end
  end

  def tag_params
    params.require(:tag).permit(:name)
  end
end
