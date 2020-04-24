class Api::V1::BaseController < ApplicationController
  protected

  def not_authenticated
    render status: 401, json: { flash: { type: 'error', message: 'ログインしてください' } }
  end
end
