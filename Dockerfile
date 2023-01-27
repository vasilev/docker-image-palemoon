# Based on https://github.com/mdouchement/docker-zoom-us
FROM ubuntu:22.04

LABEL org.opencontainers.image.source https://github.com/vasilev/docker-image-palemoon

RUN DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt install -y curl gnupg libpulse0 sudo \
    && echo 'deb https://download.opensuse.org/repositories/home:/stevenpusser/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:stevenpusser.list \
    && curl -fsSL https://download.opensuse.org/repositories/home:stevenpusser/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stevenpusser.gpg > /dev/null \
    && apt update \
    && apt install --no-install-recommends -y palemoon \
    && apt remove -y curl gnupg && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY scripts/ /var/cache/palemoon/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
