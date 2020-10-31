# Hashlog（ハッシュログ）

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/aiandrox/hashlog)](https://github.com/aiandrox/hashlog/releases)
[![Rails](https://img.shields.io/badge/Rails-v5.2.4.3-%23a72332)](https://rubygems.org/gems/rails/versions/5.2.4.4)
[![Vue](https://img.shields.io/badge/Vue-v2.6.11-%2342b77c)](https://www.npmjs.com/package/vue/v/2.6.11)
[![CircleCI](https://circleci.com/gh/aiandrox/hashlog.svg?style=shield)](https://circleci.com/gh/aiandrox/hashlog)
[![Coverage Status](https://coveralls.io/repos/github/aiandrox/hashlog/badge.svg?branch=develop)](https://coveralls.io/github/aiandrox/hashlog?branch=develop)
[![Maintainability](https://api.codeclimate.com/v1/badges/d31e5fff03ec3ea494fa/maintainability)](https://codeclimate.com/github/aiandrox/hashlog/maintainability)

### **https://hashlog.work**

## サービス概要

**ハッシュタグであなたの学びをキチンとする**

面倒くさがりツイッタラーが  
ハッシュタグを登録するだけで継続を可視化できる  
Twitter 連携型 学習記録サービスです。

[プロダクトについて](/README_product.md)

### サービスを作った思い

Twitter で学習報告をしている人を見て、「毎日学習記録を付けることはすごいことなのに、ツイートがすぐに流れてしまってあまり評価されていない気がする」と感じたことと、自分が実際に過去の記録をツイートの中から探そうとしたときに日常ツイートに埋もれていて大変だった経験から作りました。  
きちんと継続して記録したくなる仕組みを作ること、その積み上げをカレンダーの可視化やランキングで評価することで達成感を感じさせることを目的としています。

## 使用画面と機能紹介

| トップページ                                                         | 利用規約                                                                                               |
| :------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------- |
| <img src="https://i.gyazo.com/288cfef35a4c404a57b9ed80803b9f77.png"> | <img src="https://i.gyazo.com/a5df36426cae3326b9813cb2afb6eacf.png">                                   |
| 最近登録されたハッシュタグ 3 件と機能の紹介を表示する。              | ユーザー登録 / ログイン前に利用規約を表示し、ユーザーが同意した上で Twitter 認証ページへジャンプする。 |

<br>

| マイページ                                                                                                                 | ハッシュタグ登録画面                                                                                                        |
| :------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| <img src="https://i.gyazo.com/bd2b43a7a36d58c52bb49e9dccce47e0.png">                                                       | <img src="https://i.gyazo.com/5264cb248f86022f6d5fef549460ee34.png">                                                        |
| ユーザープロフィールと公開設定のみ編集できる。<br>非公開設定の場合、自分以外によるユーザーページへのアクセスが制限される。 | ハッシュタグを登録することで、自動でツイートを取得する。<br>登録後はサービス側で自動で 1 日ごとにツイートを収集し更新する。 |

<br>

| ツイート一覧ページ（マイページ）                                                                 | ツイート一覧ページ（ユーザーページ）                                    |
| :----------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------- |
| <img src="https://i.gyazo.com/30e89befc5afee6f425363b231d00ea2.png">                             | <img src="https://i.gyazo.com/99d91739e9c979287781ac9af848f53e.png">    |
| 該当のハッシュタグのツイートが表示される。<br>カレンダーにはツイートした日にマークが付いている。 | 限定公開 / 非公開設定にしたハッシュタグはユーザーページに表示されない。 |

<br>

| ハッシュタグの設定                                                                                                                      | 日付選択時                                                           |
| :-------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------- |
| <img src="https://i.gyazo.com/06af34d7b35b912ddb6c95765fc8fd23.png">                                                                    | <img src="https://i.gyazo.com/aa81ebd3412dfd89508b545767924fb1.png"> |
| 公開設定・リマインダーを設定する。<br>リマインダーで設定した日数ツイートがない場合、Bot から Twitter アカウントにメンションが送られる。 | カレンダーの日付を選択することで、その日のツイートのみ表示する。     |

<br>

| 継続率ランキング                                                           | 管理画面                                                             |
| :------------------------------------------------------------------------- | :------------------------------------------------------------------- |
| <img src="https://i.gyazo.com/33d4427f0b70ef6c42074eb87135cc05.png">       | <img src="https://i.gyazo.com/a21f086fc3dc447a5d54d502fe7c56c5.png"> |
| 公開設定になっているハッシュタグを継続率・ツイート日数でランキングにする。 | ユーザーなどの情報、定期実行の状況を確認する。                       |

<br>

## 使用技術

### バックエンド

- Ruby 2.6.6
- Rails 5.2.4.4
- RSpec 3.9
- Twitter API（外部 API）

#### 機能における主要な Gem

- sorcery（ログイン）
- twitter（TwitterAPI OAuth）
- pagy（ページネーション）
- banken（認可）
- whenever（定期実行）
- ~~sidekiq（非同期処理）~~
- administrate（管理画面）

#### ER 図

[![Image from Gyazo](https://i.gyazo.com/f2f05539bb0679ed1e64eac82e9b772b.png)](https://gyazo.com/f2f05539bb0679ed1e64eac82e9b772b)
https://drive.google.com/file/d/1xGTZvsnf1Tqezl44daZW8v8j_zwY8kEK/view?usp=sharing

[API エンドポイント一覧](/README_api_endpoint.md)

### フロントエンド

- Vue 2.6.11
- axios 0.19.2
- Vuex 3.1.3
- Vee-Validate 3.3.0
- Vuetify 2.2.21

### インフラストラクチャー

- ~~Docker~~
- Sider
- CircleCI
- Nginx 1.12.2
- puma 4.3.3
- AWS
  - VPC
  - EC2
    - Amazon Linux 2
  - RDS
    - MySQL 8.0.19
  - ~~ElastiCache(Redis)~~
  - S3
  - Cloud Front
  - ALB
  - Route53
  - ACM

#### インフラ構成図

[![Image from Gyazo](https://i.gyazo.com/77d2babccb1468a167c3e362c4d89eff.png)](https://gyazo.com/77d2babccb1468a167c3e362c4d89eff)
https://drive.google.com/file/d/1lCmn-IeardJ3zwkcgTyybtmjb9wh80Hf/view?usp=sharing

## 環境構築手順

事前に管理者から`master.key`を取得して`config`配下に置いてください。

- config/database.yml の作成

```shell
$ cp config/database.yml.default config/database.yml
```

- ローカル環境構築

```shell
$ rbenv local 2.6.6
$ nodenv local 14.2.0
$ bundle install --path vendor/bundle
$ yarn install
$ rails db:create
$ rails db:migrate
$ rake db:seed_fu  # 事前に自分のアカウントを管理ユーザーとして設定してください
```

### サーバー起動

```shell
$ rails server
$ bin/webpack-dev-server
```

上記のコマンドは`$ bundle exec foreman start`で代替可能。

### テスト実行

```shell
$ bundle exec rspec spec
```

[テスト項目一覧](/spec/rspec-output)

### 開発者用 自動ログイン

See `app/controllers/development/sessions_controller.rb`

```
/login_as/[user_id]
```
