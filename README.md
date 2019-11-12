# che-editor-vim

Eclipse Che のエディタとして Vim を使うプロジェクト。

## Example

TODO: che.openshift.io の URL


## Build

```sh
git clone --recurse -b dev http://github.com/mikoto2000/che-editor-vim.git
cd che-editor-vim
docker run -it --rm -v "$(pwd)/ttyd:/work" --workdir="/work" node yarn --cwd html/ install
docker run -it --rm -v "$(pwd)/ttyd:/work" --workdir="/work" node yarn --cwd html/ run build

docker build --build-arg http_proxy=http://host.docker.internal:3142 -t mikoto2000/che-editor-vim:dev .
```

## License:

```
Copyright (c) 2019 mikoto2000

This program and the accompanying materials are made
available under the terms of the Eclipse Public License 2.0
which is available at https://www.eclipse.org/legal/epl-2.0/
```

## Author:

mikoto2000 <mikoto2000@gmail.com>

