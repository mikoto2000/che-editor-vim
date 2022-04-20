# che-editor-vim

Eclipse Che のエディタとして Vim を使うプロジェクト。

## Example

TODO: che.openshift.io の URL


## Build

```sh
git clone --recurse http://github.com/mikoto2000/che-editor-vim.git
cd che-editor-vim
docker buildx build --build-arg http_proxy=http://host.docker.internal:3142 --platform linux/amd64,linux/arm64 --push -t mikoto2000/che-editor-vim:next .
```

## License:

```
Copyright (c) 2020-2022 mikoto2000

This program and the accompanying materials are made
available under the terms of the Eclipse Public License 2.0
which is available at https://www.eclipse.org/legal/epl-2.0/
```

## Author:

mikoto2000 <mikoto2000@gmail.com>

