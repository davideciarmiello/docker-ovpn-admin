FROM node:16.13.0-alpine3.12 AS frontend-builder
#RUN apk add --update python3 make g++ git && rm -rf /var/cache/apk/*
#RUN git clone https://github.com/flant/ovpn-admin.git /app
#RUN cd /app && git pull
COPY ./ovpn-admin/frontend/ /app
#RUN cd /app && npm install && npm run build

FROM golang:1.17.3-buster AS backend-builder
ARG TARGETOS
ARG TARGETARCH
RUN go install github.com/gobuffalo/packr/v2/packr2@latest
COPY --from=frontend-builder /app/static /app/frontend/static
COPY ./ovpn-admin /app
#COPY --from=frontend-builder /app /app
RUN cd /app && echo files in app && ls
RUN cd /app && packr2 && env CGO_ENABLED=1 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -a -tags netgo -ldflags '-linkmode external -extldflags -static -s -w' -o ovpn-admin && packr2 clean

FROM alpine:3.14
ARG TARGETOS
ARG TARGETARCH
WORKDIR /app
COPY --from=backend-builder /app/ovpn-admin /app
RUN apk add --update bash easy-rsa openssl openvpn  && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    wget https://github.com/pashcovich/openvpn-user/releases/download/v1.0.3/openvpn-user-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar xz -C /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

CMD ["/app/ovpn-admin"]
