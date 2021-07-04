# becomemo-app

Fjord Boot Camp Sinatra memo app with PostgreSQL.

## 動作環境

- Chrome だと投稿・編集・削除機能が動きません…
- Firefox か Safari でご確認ください:bow:
## 事前準備

アプリを起動する前に以下の準備をお願いします。

1. PostgreSQL のインストール
1. PostgreSQL の起動
1. DB の作成と接続
1. テーブルの作成

###  PostgreSQL のインストールと起動

例）Homebrew でのインストールと起動

```
brew install postgresql
```

```
brew services start postgresql
```

### DBとテーブルの作成

DB の作成
```
createdb -O {自身のユーザー名} becomemo
```

DB に入る
```
psql -U {自身のユーザー名} becomemo
```

テーブルの作成
```
CREATE TABLE Article
(id INTEGER PRIMARY KEY,
title TEXT,
content TEXT NOT NULL);
```

## メモアプリの起動手順

1. リポジトリをクローン
1. ディレクトリに移動 `cd becomemo-app`
1. 初回のみインストール `bundle install`
1. DBを起動
1. 起動 `bundle exec ruby app.rb`

## 削除と停止

### メモアプリの停止

ctrl + c

### テーブル・DB の削除

テーブルだけ削除する場合

```
psql -U {自身のユーザー名} becomemo （DBに入る）
DROP TABLE Article;
```

DB ごと削除する場合

```
dropdb -U {自身のユーザー名} becomemo
```

### PostgreSQL の停止・アンインストール

例）Homebrew でインストールした場合

停止
```
brew services stop postgresql
```

削除
```
brew uninstall postgresql
```
