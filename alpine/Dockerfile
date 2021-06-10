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

# XXX: libvips needs to be compiled from source because at the time of writing
# this comment (2021-06-09) no prebuilt binaries existed for arm7.
#
# Check https://github.com/libvips/libvips/releases for newer versions if
# needed.
ARG LIBVIPS_VERSION=8.10.6
RUN apk add --no-cache --upgrade --virtual .libvips-deps \
    build-base \
    expat-dev \
    imagemagick-dev \
    libexif-dev \
    libgsf-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    pkgconfig \
    tiff-dev && \
    wget -O "vips-${LIBVIPS_VERSION}.tar.gz" -q "https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.gz" && \
    tar -xf "vips-${LIBVIPS_VERSION}.tar.gz" && \
    cd "vips-${LIBVIPS_VERSION}" && \
    ./configure && \
    make && \
    make install && \
    ldconfig "/lib/ld-musl-$(uname -m).so.1" && \
    apk del --purge .libvips-deps

# Install thelounge.
ARG THELOUNGE_VERSION=4.3.0-pre.2
RUN apk add --no-cache --upgrade --virtual .thelounge-deps python build-base && \
    yarn --non-interactive --frozen-lockfile global add thelounge@${THELOUNGE_VERSION} && \
    yarn --non-interactive cache clean && \
    apk del --purge .thelounge-deps
