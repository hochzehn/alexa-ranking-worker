FROM alpine:3.3

RUN apk add --no-cache \
  bash \
  unzip \
  parallel \
  curl

ADD ./app /opt/app
VOLUME ./app/tmp /opt/app/tmp

WORKDIR /opt/app

ENTRYPOINT ["./entrypoint.sh"]
