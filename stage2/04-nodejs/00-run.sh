#!/bin/bash -e

# source: https://blog.wia.io/installing-node-js-v4-0-0-on-a-raspberry-pi
# npm needs git
if [ "${INSTALL_NODEJS}" = "1" ]; then
  NODE_VERSION=v4.0.0
  NODE_ARCH=armv7l
  if [ "${USE_QEMU}" = "1" ]; then
    NODE_ARCH=armv6l
  fi
  echo "Install nodejs ${NODE_VERSION} and npm for ${NODE_ARCH}"
  wget https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-${NODE_ARCH}.tar.gz
  tar -xvf node-${NODE_VERSION}-linux-${NODE_ARCH}.tar.gz
  cp -R node-${NODE_VERSION}-linux-${NODE_ARCH}/* ${ROOTFS_DIR}/usr/local/
  rm -rf node-${NODE_VERSION}-linux-${NODE_ARCH}*
  on_chroot << EOF
apt-get install -y git make g++
ln -s /usr/local/bin/node /usr/bin/nodejs
ln -s /usr/local/bin/node /usr/bin/node
EOF
fi
