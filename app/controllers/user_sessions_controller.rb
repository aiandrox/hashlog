class UserSessionsController < ApplicationController
  def destroy
    logout
    redirect_to root_path, notice: t('messages.logged_out')
  end
end
