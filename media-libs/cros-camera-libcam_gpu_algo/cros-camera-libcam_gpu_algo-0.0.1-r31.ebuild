# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="2923751bf31dd9e7814ecd836da87a6c816987d6"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "949959b23df79413f3956355b1a4662128f60a40" "9863ee9778012b49f27d5c4a939f6b7e6c1cf36e" "33378ea9ec0ce2140519976d43d90cb944b86813")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcam_gpu_algo"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera GPU algorithm library."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
	dolib.so "${OUT}/lib/libcam_gpu_algo.so"

	insinto /etc/init
	doins ../init/cros-camera-gpu-algo.conf

	insinto "/usr/share/policy"
	newins "../cros-camera-gpu-algo-${ARCH}.policy" cros-camera-gpu-algo.policy
}
