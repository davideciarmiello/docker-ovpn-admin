#!/bin/bash

# https://github.com/guitarrapc/githubactions-lab bash -eux 

echo script before-build.sh

mkdir -p tmp

FRONTEND_BUILDER_IMAGE=$(cat ovpn-admin/Dockerfile | grep "AS frontend-builder" | sed -e "s/^FROM //" -e "s/ AS .*//")
BACKEND_BUILDER_IMAGE=$(cat ovpn-admin/Dockerfile | grep "AS backend-builder" | sed -e "s/^FROM //" -e "s/ AS .*//")

echo FRONTEND_BUILDER_IMAGE=${FRONTEND_BUILDER_IMAGE} >> "$GITHUB_ENV"
echo BACKEND_BUILDER_IMAGE=${BACKEND_BUILDER_IMAGE} >> "$GITHUB_ENV"

echo "#!/bin/bash
echo Compiling frontend
apk add --update python3 make g++ git && rm -rf /var/cache/apk/*
cd /app && npm install && npm run build
echo 1 > frontend_builded

" > tmp/frontend-builder-entrypoint.sh
chmod +x tmp/frontend-builder-entrypoint.sh


