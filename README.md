# pi-gen
_Tool used to create the raspberrypi.org Raspbian images but in a minimal version only_

This tool was forked to be able to build a custom image ahead of a minimal official raspbian image.  
All raspberrypi packages (update-config, raspi-config, python-gpio) are available in images.  
Rigth now it takes 770MB in sd card and 35MB in RAM (tested on rpi3), bluetooth and wifi are enabled.  
The QEMU mode modify the final image to be used with Qemu but not with a real rpi, in this case the image have the suffixe -qemu.img
and can be used with the custom kernel from `https://github.com/dhruvvyas90/qemu-rpi-kernel` (tested with kernel-qemu-4.4.34-jessie).
If INSTALL_NODEJS is set then nodejs V4.0 will be install with npm.

## Dependencies

I recommand to build with docker (you will be able to build from windows or mac) else you have to install these packages:

`quilt parted realpath qemu-user-static debootstrap zerofree pxz zip dosfstools bsdtar libcap2-bin grep rsync`

## Config

Upon execution, `build.sh` will source the file `config` in the current
working directory or a file specified with `CONFIG_FILE`.  This bash shell fragment is intended to set needed
environment variables. In order to create your own config just copy the config file (use as a template).

The following environment variables for build.sh or buid-docker.sh are supported:

 * `CONFIG_FILE` (Default: config)

   The path to a file which export custom env var for the build script. You can customize these var and have an multiple config files
   In the next release it will be possible to enable some function as QEMU version of your image or other things like this.
   ** Do not remove any export ** There are no default values set in the build script.

 * `APT_PROXY` (Default: unset)

   If you require the use of an apt proxy, set it here.  This proxy setting
   will not be included in the image, making it safe to use an `apt-cacher` or
   similar package for development.

A simple example for building Raspbian:

```bash
CONFIG_FILE='my_conf' ./build.sh
```

## Config file parameters

The config file set some Parameters used by all build scripts.

  * `IMG_NAME` (Default: <string> "Raspbian")

  The name of your image.

  * `HOSTNAME` (Default: <string> "raspberrypi")

  The hostname name of the rpi.

  * `RPI_USER` (Default: <string> "pi")

  The name of the standard user.

  * `RPI_PASS` (Default: <string> "raspberry")

  The standard user password.

  * `ROOT_PASS` (Default: <string> "root")

  The root user password.

  * `USE_QEMU` (Default: <boolean> false)

  This enable the Qemu mode and set filesystem and image suffix.

  * `USE_SSH` (Default: <boolean> false)

  This start the ssh server at startup (ssh is always installed).

  * `INSTALL_NODEJS` (Default: <boolean> false)

  Install nodejs V4.x and npm for arm (arm6l if USE_QEMU == true else arm7l).

  * `KEYBOARD_CONF` (Default: <string> "fr")

  Set the keyboard layout (azerty by default).

  * `LOCALE_CONF` (Default: <string> "fr_FR.UTF-8")

  Set the locales files to be used and select the default one.

## Docker Build

```bash
CONFIG_FILE='my_conf' ./build-docker.sh
```
If everything goes well, your finished image will be in the `deploy/` folder.
You can then remove the build container with `docker rm pigen_work`

If something breaks along the line, you can edit the corresponding scripts, and
continue:

```bash
CONTINUE=1 CONFIG_FILE='my_conf' ./build-docker.sh
```

There is a possibility that even when running from a docker container, the installation of `qemu-user-static` will silently fail when building the image because `binfmt-support` _must be enabled on the underlying kernel_. An easy fix is to ensure `binfmt-support` is installed on the host machine before starting the `./build-docker.sh` script (or using your own docker build solution).

## Stage Anatomy

### Raspbian Stage Overview

The build of Raspbian is divided up into several stages for logical clarity
and modularity.  This causes some initial complexity, but it simplifies
maintenance and allows for more easy customization.

 - **Stage 0** - bootstrap.  The primary purpose of this stage is to create a
   usable filesystem.  This is accomplished largely through the use of
   `debootstrap`, which creates a minimal filesystem suitable for use as a
   base.tgz on Debian systems.  This stage also configures apt settings and
   installs `raspberrypi-bootloader` which is missed by debootstrap.  The
   minimal core is installed but not configured, and the system will not quite
   boot yet.

 - **Stage 1** - truly minimal system.  This stage makes the system bootable by
   installing system files like `/etc/fstab`, configures the bootloader, makes
   the network operable, and installs packages like raspi-config.  At this
   stage the system should boot to a local console from which you have the
   means to perform basic tasks needed to configure and install the system.
   This is as minimal as a system can possibly get, and its arguably not
   really usable yet in a traditional sense yet.  Still, if you want minimal,
   this is minimal and the rest you could reasonably do yourself as sysadmin.

 - **Stage 2** - lite system.  This stage produces the Raspbian-Lite image.  It
   installs some optimized memory functions, sets timezone and charmap
   defaults, installs fake-hwclock and ntp, wifi and bluetooth support,
   dphys-swapfile, and other basics for managing the hardware.  It also
   creates necessary groups and gives the pi user access to sudo and the
   standard console hardware permission groups.


### Stage specification
You can add other stages, I recommand you to see the original project for more informations.
