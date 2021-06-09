FROM node:lts

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
RUN apt-get update && apt-get install -y \
    build-essential \
    glib2.0-dev \
    imagemagick \
    libexif-dev \
    libexpat1-dev \
    libgsf-1-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libtiff5-dev \
    libwebp-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/* && apt-get clean

# Check https://github.com/libvips/libvips/releases for newer versions if needed.
ARG LIBVIPS_VERSION=8.10.6
RUN curl -fsSLO --compressed "https://github.com/libvips/libvips/releases/download/v${LIBVIPS_VERSION}/vips-${LIBVIPS_VERSION}.tar.gz" && \
    tar -xf vips-${LIBVIPS_VERSION}.tar.gz && \
    cd vips-${LIBVIPS_VERSION} && \
    ./configure && \
    make && \
    make install && \
    ldconfig

# Install thelounge.
ARG THELOUNGE_VERSION=4.3.0-pre.2
RUN yarn --non-interactive --frozen-lockfile global add thelounge@${THELOUNGE_VERSION} && \
    yarn --non-interactive cache clean
