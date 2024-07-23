ARG POSTGRES_VERSION=16
FROM postgres:${POSTGRES_VERSION}-alpine

RUN apk add --no-cache bash curl age rclone \
  && mkdir -p /root/.config/rclone \
  && touch /root/.config/rclone/rclone.conf

COPY backup.sh /usr/local/bin/

CMD ["backup.sh"]
