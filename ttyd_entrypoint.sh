#!/bin/bash

echo "Start project clone..."
che-project-cloner
echo "done."

echo "Create link if _vim exists..."
if [ -d ~/_vim ]; then
    if [ ! -L ~/.vim ]; then
        ln -s ~/_vim ~/.vim
    fi
fi
echo "done."


watch -n 180 curl --insecure -XPUT ${CHE_API_EXTERNAL}/activity/${CHE_WORKSPACE_ID}?token=${CHE_MACHINE_TOKEN} > /dev/null &

clear

while true
do
    vim
done

