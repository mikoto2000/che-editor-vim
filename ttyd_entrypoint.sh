#!/bin/bash

echo "Start project clone..."
che-project-cloner
echo "done."

watch -n 180 curl -XPUT ${CHE_API_EXTERNAL}/activity/${CHE_WORKSPACE_ID}?token=${CHE_MACHINE_TOKEN} > /dev/null &

while true
do
    vim
done

