module LoginHelper
  def login_as(user)
    get login_as_path(user)
  end
end