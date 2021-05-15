# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="retrorun"
PKG_VERSION="f93ac7ecc4b6e20ddc763065de6ad0ba342396fe"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/christianhaitian/retrorun-go2"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain libgo2 libdrm"
PKG_TOOLCHAIN="make"

pre_configure_target() {
	CFLAGS+=" -I$(get_build_dir libdrm)/include/drm"
	CFLAGS+=" -I$(get_build_dir linux)/include/uapi"
	CFLAGS+=" -I$(get_build_dir linux)/tools/include"
	PKG_MAKE_OPTS_TARGET=" config=release ARCH=" 
}

makeinstall_target() {
	mkdir -p $INSTALL/usr/bin
	cp retrorun $INSTALL/usr/bin
}
