class Mypage::BaseController < ApplicationController
  before_action :require_login
end
