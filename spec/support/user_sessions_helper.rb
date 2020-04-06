module UserSessionsHelper
  def login_as(user)
    get login_as_path(user)
    expect(logged_in?).to be_truthy
  end

  def logged_in? # TODO sessionに値が入っていないとNoMethodErrorになるのでゴリ押しでfalseを返している
    !!session[:user_id]
  rescue StandardError
    false
  end
end
