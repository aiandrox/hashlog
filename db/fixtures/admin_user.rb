User.seed_once(
  id: 1,
  twitter_id: '1242379749650907137',
  screen_name: 'hash1og',
  name: 'Hashlog',
  description: '管理ユーザーです。',
  privacy: :closed,
  role: :admin,
  avatar_url: 'https://pbs.twimg.com/profile_images/1267362108703817728/bSK1Ux-E.jpg',
)

Authentication.seed_once(
  user_id: 1,
  provider: "twitter",
  uid: "1242379749650907137"
)

User.seed_once(
  id: 2,
  twitter_id: '1048451188209770497',
  screen_name: 'aiandrox',
  name: 'END',
  description: '管理ユーザーです。',
  privacy: :published,
  role: :admin,
  avatar_url: 'https://pbs.twimg.com/profile_images/1250601087318413313/yMmfgkOX.jpg',
)
Authentication.seed_once(
  user_id: 2,
  provider: "twitter",
  uid: "1048451188209770497"
)
