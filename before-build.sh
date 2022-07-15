#!/bin/bash

# https://github.com/guitarrapc/githubactions-lab bash -eux 

echo script before-build.sh

mkdir -p tmp

DOCKERFILE=./ovpn-admin/Dockerfilebak
[ ! -d "./ovpn-admin" ] && git clone https://github.com/flant/ovpn-admin.git
[ ! -f "${DOCKERFILE}" ] && cp ovpn-admin/Dockerfile "${DOCKERFILE}"

FRONTEND_BUILDER_IMAGE=$(cat "${DOCKERFILE}" | grep "AS frontend-builder" | sed -e "s/^FROM //" -e "s/ AS .*//")
BACKEND_BUILDER_IMAGE=$(cat "${DOCKERFILE}" | grep "AS backend-builder" | sed -e "s/^FROM //" -e "s/ AS .*//")

#echo ${FRONTEND_BUILDER_IMAGE}

echo FRONTEND_BUILDER_IMAGE=${FRONTEND_BUILDER_IMAGE} >> "$GITHUB_ENV"
echo BACKEND_BUILDER_IMAGE=${BACKEND_BUILDER_IMAGE} >> "$GITHUB_ENV"

#FRONTEND_BUILDER_SCRIPT="
#echo Compiling frontend
#apk add --update python3 make g++ git && rm -rf /var/cache/apk/*
#cd /app && npm install && npm run build
#echo 1 > frontend_builded
#echo frontend compiled
#"
#echo "#!/bin/sh" > ovpn-admin-custom/frontend/build_from_docker.sh
#echo "${FRONTEND_BUILDER_SCRIPT}" >> ovpn-admin-custom/frontend/build_from_docker.sh

#FRONTEND_BUILDER_RUN="sh /workspace/tmp/frontend-builder-entrypoint.sh"
FRONTEND_BUILDER_RUN="sh /app/build_from_docker.sh"

echo FRONTEND_BUILDER_RUN=${FRONTEND_BUILDER_RUN} >> "$GITHUB_ENV"

#chmod +x tmp/frontend-builder-entrypoint.sh

cp -R ovpn-admin-custom/* ovpn-admin/
