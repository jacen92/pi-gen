#!/bin/bash -e

# source:
# - docker: https://www.raspberrypi.org/blog/docker-comes-to-raspberry-pi/
# - docker-compose: http://hrb85-1-88-121-176-85.fbx.proxad.net/blog/201607271335/
if [ "${INSTALL_DOCKER}" = "1" ]; then

  on_chroot << EOF
chown -R ${RPI_USERNAME}:${RPI_USERNAME} /home/${RPI_USERNAME}
curl -sSL https://get.docker.com | sh
usermod -aG docker ${RPI_USERNAME}
pip install docker-compose
EOF

fi
