describe TwitterAPI::User do
  let(:user) { create(:user, twitter_id: '1048451188209770497') }
  describe '#call', vcr: { cassette_name: 'twitter_api/user_show/hashlog' } do
    let(:user_data) { TwitterAPI::User.new(user) }
    it 'TwitterのアカウントからユーザーのJSONを取得する' do
      expect(user_data.call).to eq(
        { name: 'Hashlog',
          screen_name: 'Hash1og',
          description: 'あなたの学習を可視化するツイート記録サービス',
          avatar_url: 'https://pbs.twimg.com/profile_images/1270548562221215744/_lvOIniK_normal.jpg'
        }
      )
    end
    # ユーザーを取得できなかった場合はコントローラで例外処理をする
  end
end
