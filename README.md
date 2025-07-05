# che-editor-vim

Eclipse Che のエディタとして Vim を使うプロジェクト。

## Usage:

### エディタの指定方法

1. Eclipse Che のダッシュボードを開く
    - ex: `https://workspaces.openshift.com/`
2. `Editor Selector` -> `Use an Editor Definition` -> `Editor Definition` に以下 che-editor-vim の定義をペースト
    - `https://raw.githubusercontent.com/mikoto2000/che-editor-vim/refs/heads/main/devfile.yaml`

See: [クラウド IDE でサーバーを立ててエンドポイントへ接続 with Vim - YouTube](https://www.youtube.com/watch?v=2JuRGNzFPzI)


### che-editor-vim 向けの組み込みコマンド

- `che-terminal-connector`: サイドカーコンテナに接続するためのコマンド
- `che-endpoint-viewer`: 定義したエンドポイント一覧を表示するためのコマンド


## Build:

```sh
git clone --recurse http://github.com/mikoto2000/che-editor-vim.git
cd che-editor-vim
docker build --build-arg http_proxy=http://host.docker.internal:3142 -t mikoto2000/che-editor-vim:next .
```

## License:

```
Copyright (c) 2020-2025 mikoto2000

This program and the accompanying materials are made
available under the terms of the Eclipse Public License 2.0
which is available at https://www.eclipse.org/legal/epl-2.0/
```

## Author:

mikoto2000 <mikoto2000@gmail.com>
