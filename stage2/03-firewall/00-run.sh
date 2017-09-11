#!/bin/bash -e

if [ "${USE_IPTABLE}" = "1" ]; then
  # NOTE: install basic rules and enable iptables
  echo "Configure firewall"
  install -m 755 files/configure_iptables       ${ROOTFS_DIR}/etc/init.d/
  install -m 755 files/set_iptables_rules.sh    ${ROOTFS_DIR}/usr/bin/
  chmod +x ${ROOTFS_DIR}/etc/init.d/configure_iptables
  chmod +x ${ROOTFS_DIR}/usr/bin/set_iptables_rules.sh
  on_chroot << EOF
systemctl enable configure_iptables
EOF

  # NOTE: if there are other applications then add rules here
if [ "${USE_SSH}" = "1" ]; then
    echo "Authorize SSH in iptables"
    echo "# SSH In/Out" >> ${ROOTFS_DIR}/usr/bin/set_iptables_rules.sh
    echo "iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT" >> ${ROOTFS_DIR}/usr/bin/set_iptables_rules.sh
    echo "iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT" >> ${ROOTFS_DIR}/usr/bin/set_iptables_rules.sh
  fi
else
  echo "Firewall is disabled"
fi
