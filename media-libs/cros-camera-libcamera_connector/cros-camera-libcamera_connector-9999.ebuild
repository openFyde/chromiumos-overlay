# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcamera_connector"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera connector for simpler uses."

LICENSE="BSD-Google"
KEYWORDS="~*"

BDEPEND="virtual/pkgconfig"

src_install() {
	dolib.so "${OUT}/lib/libcamera_connector.so"
	cros-camera_dopc ../libcamera_connector.pc.template
	cros-camera_doheader ../../include/cros-camera/camera_service_connector.h
}

