# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="07f7e8eb86660a0b827c1a85fa3991ee29cbb52b"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d58be6324ba2a1d0452d23bafb39c869c5ed2cd6" "208baf1260a799a3ae3ef54d4cecb2403669a4f6" "4cc600d625ecfdac13d984d9190d63a8970b0a4b" "ab72b93074396d3428b557e2e00d64f487fab1e1" "e878c3ec9ca8c15b6f63f45f4c95e8aaa646f0ad")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/common/jpeg/libjda_test"

inherit cros-camera cros-workon platform

DESCRIPTION="End to end test for JPEG decode accelerator"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="dev-cpp/gtest"

DEPEND="${RDEPEND}
	media-libs/cros-camera-libjda"

src_install() {
	platform_src_install
	dobin "${OUT}/libjda_test"
}
