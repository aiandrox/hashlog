## API エンドポイント一覧

### GET /api/v1/users/current

ログインユーザーを取得する。

### PATCH /api/v1/users/current

ユーザー情報を更新する。  
params: `description`, `privacy`

### PATCH /api/v1/users/current/twitter_data

Twitter のユーザーデータを取得し、ユーザー情報を更新する。

### DELETE /api/v1/users/current

ユーザーを削除する。

### GET /api/v1/users/current/registered_tags

ログインユーザーの持つ`registered_tag`をすべて取得する。

### GET /api/v1/users

すべてのユーザーを取得する。

### GET /api/v1/users/:uuid

指定のユーザーを取得する。

### GET /api/v1/users/:user_uuid/registered_tags

指定のユーザーの持つ`registered_tag`の中で公開設定のものをすべて取得する。

### GET /api/v1/registered_tags

公開設定になっている`registered_tags`を取得する。  
query: `page`, `count`

### POST /api/v1/registered_tags

新しくタグを登録する。`tag`は既に名前が合致するものがあればそれを使い、合致しなかった場合は新規作成する。  
params: `name`

### GET /api/v1/registered_tags/:id

指定の`registered_tag`を取得する。

### PATCH /api/v1/registered_tags/:id

指定の`registered_tag`を更新する。  
params: `privacy`, `remind_day`

### DELETE /api/v1/registered_tags/:id

指定の`registered_tag`を削除する。

### GET /api/v1/registered_tags/:registered_tag_id/tweets

指定の`registered_tag`のツイートを取得する。  
query: `page`, `date`

### GET /api/v1/registered_tags/persistences

ツイート日数が 0 日のものは切り捨て、継続率が高い順（次点でツイート日数が多い順）に並べた`registered_tags`を取得する。

### GET /api/v1/tags

人気順に並べた全てのタグを取得する。  
query: `page`, `count`

### DELETE /api/v1/logout

ログアウトする。

### POST /api/v1/guest_login

ゲストユーザーとしてログインする。

### GET /login_as/:user_id

指定のユーザーとしてログインする。（開発環境のみ）
