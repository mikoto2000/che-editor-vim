#!/bin/bash

cd /projects

echo "Start project clone..."
che-project-cloner
echo "done."

while true
do
    HOME=/projects vim
done

