#!/bin/bash

echo "Create link if _vim exists..."
if [ -d ~/_vim ]; then
    if [ ! -L ~/.vim ]; then
        ln -s ~/_vim ~/.vim
    fi
fi
echo "done."

# ワークスペースの強制終了を防ぐために
# che-machine-exec に定期的にアクティビティを送信
watch -n 1500 curl -X POST localhost:${MACHINE_EXEC_PORT}/activity/tick > /dev/null &

clear

while true
do
    vim
done

