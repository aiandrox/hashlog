module TwitterApiMockHelper
  def twitter_client(user, tag_name, since_id=nil)
    @twitter_client ||= TwitterAPI::Client.new(user, tag_name, since_id)
  end

  # メソッドを実行するかどうかだけ確かめる（TwitterAPIの返り値はどうでもいい）とき
  def set_twitter_mock(user, tag_name)
    client_mock = double('Twitter Client')
    allow(client_mock).to receive(:search)
    allow(client_mock).to receive(:premium_search)
    allow(client_mock).to receive(:oembeds).and_return([])
    allow(twitter_client(user, tag_name)).to receive(:client).and_return(client_mock)
  end
end
