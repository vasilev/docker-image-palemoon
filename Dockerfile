# Based on https://github.com/mdouchement/docker-zoom-us
FROM ubuntu:18.04

LABEL org.opencontainers.image.source https://github.com/vasilev/docker-image-palemoon

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y gnupg libgl1 libpulse0 sudo wget \
    && echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/xUbuntu_18.04/ /' > /etc/apt/sources.list.d/home:stevenpusser.list \
    && wget -nv https://download.opensuse.org/repositories/home:/stevenpusser/xUbuntu_18.04/Release.key -O /tmp/Release.key \
    && apt-key add - < /tmp/Release.key \
    && apt-get update \
    && apt-get install -y palemoon \
    && apt-get remove -y gnupg wget && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY scripts/ /var/cache/palemoon/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
