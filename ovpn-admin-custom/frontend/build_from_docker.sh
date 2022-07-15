#!/bin/sh

if [ ! -f "/app/frontend_builded" ]
then
    echo Compiling frontend
    apk add --update python3 make g++ git && rm -rf /var/cache/apk/*
    cd /app && npm install && npm run build
    echo 1 > /app/frontend_builded
    echo frontend compiled
else
    echo "frontend already compiled"
fi
