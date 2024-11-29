# Partially based on https://github.com/mdouchement/docker-zoom-us
FROM ubuntu:22.04

LABEL org.opencontainers.image.source=https://github.com/vasilev/docker-image-palemoon

COPY scripts/ /var/cache/palemoon/
COPY entrypoint.sh /sbin/entrypoint.sh

RUN export DEBIAN_FRONTEND=noninteractive \
    && chmod 755 /sbin/entrypoint.sh \
    && apt-get update \
    && apt-get install -y  --no-install-recommends libpulse0 sudo wget xz-utils \
    && apt-get install -y  --no-install-recommends libasound2 libdbus-glib-1-2 libgtk2.0-0 libxrender1 libxt6 \
    && wget -O /tmp/palemoon.tar.xz 'https://www.palemoon.org/download.php?mirror=us&bits=64&type=linuxgtk2' \
    && tar -C /usr/local -xf /tmp/palemoon.tar.xz \
    && update-alternatives --install /usr/bin/palemoon palemoon /usr/local/palemoon/palemoon 80 \
    && apt-get remove -y wget xz-utils && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENTRYPOINT ["/sbin/entrypoint.sh"]
