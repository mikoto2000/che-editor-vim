#!/bin/bash

set -e
set -x

USER_ID=$(id -u)
GROUP_ID=$(id -G | cut -d " " -f 2)
export USER_ID
export GROUP_ID

if ! whoami >/dev/null 2>&1; then
    echo "${USER_NAME:-user}:x:${USER_ID}:${GROUP_ID}:${USER_NAME:-user} user:${HOME}:/bin/bash" >> /etc/passwd
    echo "${USER_NAME:-user}:x:${GROUP_ID}:" >> /etc/group
fi

# Grant access to projects volume in case of non root user with sudo rights
if [ "${USER_ID}" -ne 0 ] && command -v sudo >/dev/null 2>&1 && sudo -n true > /dev/null 2>&1; then
    sudo chown "${USER_ID}:${GROUP_ID}" /projects
fi

ttyd -p 3100 --writable /ttyd_entrypoint.sh

