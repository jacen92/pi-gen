#!/bin/bash -e

rm -f "${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/wait.conf"
install -m 644 files/mini_playlist.m3u  "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"
