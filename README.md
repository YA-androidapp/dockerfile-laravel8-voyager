# dockerfile-laravel8-voyager

---

Voyager をセットアップした Laravel8 をビルトインサーバーで起動する

## コンテナを実行

```bash
docker run -itd --name voyager-on-laravel8 -v $PWD/storage/app/public:/src/storage/app/public -p 8000:8000 yaand/voyager-on-laravel8:latest
```

http://localhost:8000

## コンテナの操作

```bash
# コンテナをビルドしてDocker Hubにプッシュ
docker build -t yaand/voyager-on-laravel8:latest .
docker push yaand/voyager-on-laravel8:latest

# コンテナを実行
docker run -itd --name voyager-on-laravel8 -p 8000:8000 yaand/voyager-on-laravel8:latest

# 内容を確認
docker exec -it voyager-on-laravel8 /bin/bash

# 変更をコミットして再度プッシュ
docker commit voyager-on-laravel8 yaand/voyager-on-laravel8:latest
docker push yaand/voyager-on-laravel8:latest
```

---

Copyright (c) 2021 YA-androidapp(https://github.com/YA-androidapp) All rights reserved.
