#!/bin/bash

echo "Create link if _vim exists..."
if [ -d ~/_vim ]; then
    if [ ! -L ~/.vim ]; then
        ln -s ~/_vim ~/.vim
    fi
fi
echo "done."

clear

while true
do
    vim
done

