# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="090c2394fd67901d856fbe89e8aad0f111abdb42"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "55939c6ae7e4e501ab2d3534ef3c746607fcc2cd" "e1f223c8511c80222f764c8768942936a8de01e4" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "3a7fe308900b1e42544d6127096c941e90fed922" "3f79a0550c97fd32e71dd5ebe355780aad06c968" "fda2d0c3096e3691b413cfb9cf7e3c1238d38856" "3b757cd929e4972887fb9072b138bccff2001f48" "546d612834bb46518d8ed157a8923c49016e2fb5" "1f14ece34022286d96351e9e4992d8073e6d16ce" "5be17ba0d331df49cda26486f5a3e5d5db8b480a" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "23cfffa30acecea70e6943db00f0f48222d8412b" "1df96416290731160d582fa8ffa8f156b2fbac53")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE=".gn common-mk metrics camera/build camera/common camera/features camera/gpu camera/include camera/mojo chromeos-config iioservice/libiioservice_ipc iioservice/mojo ml_core ml_core/mojo"

DESCRIPTION="Tests Effects Stream Manipulator"

PLATFORM_SUBDIR="camera/features/effects/tests"

SRC_URI="gs://chromeos-localmirror/distfiles/ml-core-cros_effects_test_assets-0.0.5.tar.xz"
RESTRICT="mirror"

inherit cros-workon unpacker platform

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT=0

RDEPEND="
	chromeos-base/cros-camera-android-deps:=
	chromeos-base/cros-camera-libs:=
	chromeos-base/dlcservice:=
	chromeos-base/dlcservice-client:=
	dev-libs/ml-core:=
"

DEPEND="${RDEPEND}"

src_unpack() {
	unpacker
	platform_src_unpack
}

src_install() {
	platform_src_install

	into /usr/local
	dobin "${OUT}"/cros_effects_sm_tests

	insinto /usr/local/share/ml-core-effects-test-assets
	doins -r "${WORKDIR}"/cros_effects_test_assets/*
}
