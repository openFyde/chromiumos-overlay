# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcam_gpu_algo"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera GPU algorithm library."

LICENSE="BSD-Google"
KEYWORDS="~*"

RDEPEND="media-libs/cros-camera-effect-portrait-mode"

DEPEND="${RDEPEND}"

src_install() {
	dolib.so "${OUT}/lib/libcam_gpu_algo.so"
}
