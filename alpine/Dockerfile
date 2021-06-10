FROM node:lts-alpine

ENV NODE_ENV production

ENV THELOUNGE_HOME "/var/opt/thelounge"
VOLUME "${THELOUNGE_HOME}"

# Expose HTTP.
ENV PORT 9000
EXPOSE ${PORT}

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["thelounge", "start"]

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Install thelounge.
ARG THELOUNGE_VERSION=4.3.0-pre.2
RUN apk add --no-cache --upgrade --virtual .thelounge-deps python build-base glib-dev && \
    # Install vips-dev from edge since at least version 8.10.6 is needed by
    # sharp and no precompiled binary is available for linuxmusl-armv7 at the
    # time of writing (2021-06-10).
    apk add \
    imagemagick-dev \
    libexif-dev \
    libheif-dev \
    libimagequant-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    tiff-dev \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main && \
    apk add vips-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    yarn --non-interactive --frozen-lockfile global add thelounge@${THELOUNGE_VERSION} && \
    yarn --non-interactive cache clean && \
    apk del --purge .thelounge-deps
