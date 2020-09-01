#!/bin/bash -e

on_chroot << EOF
raspi-config nonint do_camera 1
raspi-config nonint do_i2c 1
raspi-config nonint do_spi 1

git clone https://github.com/respeaker/seeed-voicecard -b master
cd seeed-voicecard
./install.sh
cd ../ && rm -rf seeed-voicecard
EOF
