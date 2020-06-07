User.seed_once(
  id: 1,
  twitter_id: '1242379749650907137',
  screen_name: 'hash1og',
  name: 'Hashlog',
  description: '管理ユーザーです。',
  privacy: :closed,
  role: :admin,
  avatar_url: 'https://pbs.twimg.com/profile_images/1267362108703817728/bSK1Ux-E.jpg'
)

Authentication.seed(
  user_id: 1,
  provider: "twitter",
  uid: "1242379749650907137"
)

User.seed(
  id: 2,
  twitter_id: 'none',
  screen_name: 'hash1og',
  name: 'ゲストユーザー',
  description: 'ゲストユーザーです。ユーザー情報の編集はできません。',
  privacy: :published,
  role: :guest
end
