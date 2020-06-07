User.seed(
  id: 2,
  twitter_id: 'none',
  screen_name: 'hash1og',
  name: 'ゲストユーザー',
  description: "ゲストユーザーです。ユーザー情報の編集はできません。\n#Hashlog を登録するとツイートを取得できます。",
  privacy: :published,
  role: :guest,
  avatar_url: 'https://pbs.twimg.com/profile_images/1267362108703817728/bSK1Ux-E.jpg'
)

Tag.seed(
  id: 1,
  name: 'Hashlog',
)

RegisteredTag.seed(
  id: 1,
  user_id: 2,
  tag_id: 1,
)
