module JsonAPIHelper
  def json
    JSON.parse(response.body)
  end
end
