# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d290f731c4d623269bf6a259a351bf92eb5f4854"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "208baf1260a799a3ae3ef54d4cecb2403669a4f6" "4cc600d625ecfdac13d984d9190d63a8970b0a4b" "aa81756947ecfdd38b22f42eed8eeafa40431079")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/libcam_gpu_algo"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS camera GPU algorithm library."

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="media-libs/cros-camera-effect-portrait-mode"

DEPEND="${RDEPEND}"

src_install() {
	dolib.so "${OUT}/lib/libcam_gpu_algo.so"
}
