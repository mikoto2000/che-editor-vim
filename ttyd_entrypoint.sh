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

echo "check cacert."
if [ -e /tmp/che/secret/ca.crt ] ; then
    SELF_SIGNED_CERT_OPTION="--cacert /tmp/che/secret/ca.crt"
else
    SELF_SIGNED_CERT_OPTION=""
fi

watch -n 180 curl $SELF_SIGNED_CERT_OPTION -XPUT ${CHE_API_EXTERNAL}/activity/${CHE_WORKSPACE_ID}?token=${CHE_MACHINE_TOKEN} > /dev/null &

clear

while true
do
    vim
done

