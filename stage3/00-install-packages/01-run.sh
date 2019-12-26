#!/bin/bash -e

on_chroot << EOF
update-alternatives --install /usr/bin/x-www-browser \
  x-www-browser /usr/bin/chromium-browser 86
update-alternatives --install /usr/bin/gnome-www-browser \
  gnome-www-browser /usr/bin/chromium-browser 86

# build and install freecad
rm -rf 0.18.4*
wget https://github.com/FreeCAD/FreeCAD/archive/0.18.4.zip && unzip 0.18.4.zip
mkdir build && cd build
cmake -DPYTHON_EXECUTABLE=/usr/bin/python2.7 \
      -DPYTHON_INCLUDE_DIR=/usr/include/python2.7m \
      -DPYTHON_LIBRARY=/usr/lib/arm-linux-gnueabihf/libpython2.7m.so \
      -DPYTHON_PACKAGES_PATH=/usr/local/lib/python2.7/dist-packages/ \
      ../FreeCAD-0.18.4
make -j4 && make install
cd .. && rm -rf build 0.18.4.zip

# install Cura
cd /home/${USERNAME}
wget https://www.dropbox.com/sh/s43vqzmi4d2bqe2/AADh446N1PpjvMnlv47DkGtra/Cura-mb-master-armhf-20191214.AppImage
chmod 755 Cura-mb-master-armhf-20191214.AppImage

EOF
