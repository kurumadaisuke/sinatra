# sinatra
## メモアプリ導入手順

1)メモアプリ導入ディレクトリの作成,移動
```
base ❯ mkdir memoapp
base ❯ cd memoapp
```

2)git cloneによるファイルのダウンロード
```
base ❯ git clone https://github.com/kurumadaisuke/sinatra.git
```

3)Gemfileによるインストール
```
base ❯ bundle install
```

4)テーブルの作成
```
psql -d [dbname] -U [username] -f dbinit.sql 
```

4)メモアプリ起動
```
base ❯ bundle exec ruby memoapp.rb
```

ブラウザにてメモアプリの起動を確認
http://localhost:4567/