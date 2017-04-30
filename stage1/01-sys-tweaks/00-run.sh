#!/bin/bash -e

install -d ${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d
install -m 644 files/noclear.conf ${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/noclear.conf
install -m 744 files/policy-rc.d ${ROOTFS_DIR}/usr/sbin/policy-rc.d #TODO: Necessary in systemd?
install -v -m 644 files/fstab ${ROOTFS_DIR}/etc/fstab

on_chroot << EOF
if ! id -u ${RPI_USER} >/dev/null 2>&1; then
	adduser --disabled-password --gecos "" ${RPI_USER}
fi
echo "${RPI_USER}:${RPI_PASS}" | chpasswd
echo "root:${ROOT_PASS}" | chpasswd
EOF
