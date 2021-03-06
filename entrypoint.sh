#!/bin/bash
# Based on https://github.com/mdouchement/docker-zoom-us
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}

PALEMOON_USER=palemoon
PALEMOON_HOME=/home/${PALEMOON_USER}

install_palemoon() {
  echo "Installing palemoon-wrapper..."
  install -m 0755 /var/cache/palemoon/palemoon-wrapper /target/
  echo "Installing palemoon..."
  ln -sf palemoon-wrapper /target/palemoon
}

uninstall_palemoon() {
  echo "Uninstalling palemoon-wrapper..."
  rm -rf /target/palemoon-wrapper
  echo "Uninstalling palemoon..."
  rm -rf /target/palemoon
}

create_user() {
  # create group with USER_GID
  if ! getent group ${PALEMOON_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${PALEMOON_USER} >/dev/null 2>&1
  fi

  # create user with USER_UID
  if ! getent passwd ${PALEMOON_USER} >/dev/null; then
    adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
      --gecos 'Palemoon' ${PALEMOON_USER} >/dev/null 2>&1
  fi

  mkdir ${PALEMOON_HOME}/.cache
  if [ ! -d ${PALEMOON_HOME}/.moonchildproductions/cache ]; then
    mkdir ${PALEMOON_HOME}/.moonchildproductions/cache
  fi

  chown ${PALEMOON_USER}:${PALEMOON_USER} -R ${PALEMOON_HOME}
  adduser ${PALEMOON_USER} audio
}

launch_palemoon() {
  cd ${PALEMOON_HOME}
  ln -s .moonchildproductions '.moonchild productions'
  ln -s ${PALEMOON_HOME}/.moonchildproductions/cache .cache/'moonchild productions'
  exec sudo -HEu ${PALEMOON_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" $@
}

case "$1" in
  install)
    install_palemoon
    ;;
  uninstall)
    uninstall_palemoon
    ;;
  palemoon)
    create_user
    echo "$1"
    launch_palemoon $@
    ;;
  *)
    exec $@
    ;;
esac
