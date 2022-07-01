# Hashlog（ハッシュログ）

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/aiandrox/hashlog)](https://github.com/aiandrox/hashlog/releases)
[![Rails](https://img.shields.io/badge/Rails-v6.1.6-%23a72332)](https://rubygems.org/gems/rails/versions/6.1.6)
[![Vue](https://img.shields.io/badge/Vue-v2.6.14-%2342b77c)](https://www.npmjs.com/package/vue/v/2.6.14)
[![CircleCI](https://circleci.com/gh/aiandrox/hashlog.svg?style=shield)](https://circleci.com/gh/aiandrox/hashlog)
[![Coverage Status](https://coveralls.io/repos/github/aiandrox/hashlog/badge.svg?branch=develop)](https://coveralls.io/github/aiandrox/hashlog?branch=develop)
[![Maintainability](https://api.codeclimate.com/v1/badges/d31e5fff03ec3ea494fa/maintainability)](https://codeclimate.com/github/aiandrox/hashlog/maintainability)

### **https://hashlog.work**

## サービス概要

**ハッシュタグであなたの学びをキチンとする**

面倒くさがりツイッタラーが
ハッシュタグを登録するだけで継続を可視化できる
Twitter 連携型 学習記録サービスです。

[以前のREADME](/README_old.md)<br>
[プロダクトについて](/README_product.md)

## 使用画面と機能

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


## 関連記事

- [ポートフォリオレビュー会 vol\.1 イベントレポート \| RUNTEQ \- 公式ブログ](https://blog.runteq.jp/programming-career/portfolio/3060/)

- [ポートフォリオレビュー会の感想｜aiandrox｜note](https://note.com/aiandrox/n/n18598a9c0c9d)

- [【Rails】未経験者がポートフォリオを作って感じたこと、指摘されたこと \- Qiita](https://qiita.com/aiandrox/items/cd0eaac79bd1d313f76d)
