describe TwitterAPI::User do
  let(:user) do
    create(
      :user,
      name: '古い名前',
      screen_name: '古いID',
      description: '古い詳細',
      avatar_url: 'old_image',
      twitter_id: '1048451188209770497'
    )
  end
  describe '#call', vcr: { cassette_name: 'twitter_api/user_show/hashlog' } do
    let(:user_data) { TwitterAPI::User.new(user) }
    subject { user_data.call }
    it 'Twitterのアカウントから取得したユーザーのデータを更新する' do
      expect { subject }.to change { user.reload.name }.to('Hashlog').from('古い名前')
    end
    it { expect { subject }.to change { user.reload.screen_name }.to('Hash1og').from('古いID') }
    it { expect { subject }.to change { user.reload.avatar_url }.to('https://pbs.twimg.com/profile_images/1270548562221215744/_lvOIniK.jpg').from('old_image') }
    it { expect { subject }.not_to change { user.reload.description }.from('古い詳細') }

    context 'Twitter::Error::NotFoundのとき' do
      before do
        allow_any_instance_of(Twitter::REST::Client).to receive(:user).and_raise(Twitter::Error::NotFound)
      end
      it { expect { subject }.not_to change { user.reload.name }.from('古い名前') }
      it { expect { subject }.to change { user.reload.role }.to('deleted').from('general') }
    end
  end
end
