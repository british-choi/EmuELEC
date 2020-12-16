# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="openbor"
PKG_VERSION="d9ff4596baad6da6e1bbd1002bc9879974ff365d"
PKG_SHA256="09f06f7f54fe0d7f3fe4f3dffbc3efa92da4662e87a9e03aab99754a6684c593"
PKG_ARCH="any"
PKG_SITE="https://github.com/DCurrent/openbor"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain SDL2-git libogg libvorbisidec libvpx libpng16"
PKG_SHORTDESC="OpenBOR is the ultimate 2D side scrolling engine for beat em' ups, shooters, and more! "
PKG_LONGDESC="OpenBOR is the ultimate 2D side scrolling engine for beat em' ups, shooters, and more! "
PKG_TOOLCHAIN="make"

if [ "$DEVICE" == "OdroidGoAdvance" ] || [ "$DEVICE" == "GameForce" ]; then
PKG_PATCH_DIRS="OdroidGoAdvance"
fi


if [[ "$ARCH" == "arm" ]]; then
	PKG_PATCH_DIRS="${ARCH}"
else
	PKG_PATCH_DIRS="emuelec-aarch64"
fi

if [ "$DEVICE" == "RG351P" ]; then
  PKG_PATCH_DIRS="RG351P"
fi

pre_configure_target() {
  PKG_MAKE_OPTS_TARGET="BUILD_LINUX_${ARCH}=1 \
                        -C ${PKG_BUILD}/engine \
                        SDKPATH="${SYSROOT_PREFIX}"
                        PREFIX=${TARGET_NAME}"
}

pre_make_target() {
  #### Fix compile error in commit version e761464 ####
  sed -i "s|O_BINARY, per) == -1)|O_BINARY, per)) == -1)|" $PKG_BUILD/engine/source/gamelib/packfile.c
  #####################################################
cd $PKG_BUILD/engine
./version.sh
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp `find . -name "OpenBOR.elf" | xargs echo` $INSTALL/usr/bin/OpenBOR
    cp $PKG_DIR/scripts/*.sh $INSTALL/usr/bin
    chmod +x $INSTALL/usr/bin/*
    mkdir -p $INSTALL/usr/config/openbor  
	if [ "$DEVICE" == "OdroidGoAdvance" ] || [ "$DEVICE" == "GameForce" ]; then
		cp $PKG_DIR/config/master_odroidgoa_v11.cfg $INSTALL/usr/config/openbor/master.cfg
	elif [ "$DEVICE" == "RG351P" ]; then
		cp $PKG_DIR/config/master_rg351p.cfg $INSTALL/usr/config/openbor/master.cfg
	else
		cp $PKG_DIR/config/master.cfg $INSTALL/usr/config/openbor/master.cfg
	fi
   } 
