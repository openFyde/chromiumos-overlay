# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="cdee985de3f3fd08bdb2e62fc7f668f8d22955a4"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "1a09c812bb71c011b30f99f188c1fc7c39fc2f4c" "d08b0de17491f94bdaf6aa7564df6f074fb18383" "cf397e9600a0b2d153f579c58419577cfca75ab7")
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
