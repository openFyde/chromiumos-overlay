# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="ae4596f82377173dbc159973e5f1c48ec3b7db66"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "5c650d2e8bff1463d8f94a4e169be79a54b87a3b" "33f5c85605bbd9799200a560b8c3c77aec28a377" "94b68506644467afb2672fbb562f302dc8bcf738")
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
}
