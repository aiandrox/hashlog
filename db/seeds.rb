User.create!(
  twitter_id: 'none',
  name: 'ゲストユーザー',
  description: 'ゲストユーザーです。ユーザー情報の編集はできません。',
  privacy: :published,
  role: :guest
)
