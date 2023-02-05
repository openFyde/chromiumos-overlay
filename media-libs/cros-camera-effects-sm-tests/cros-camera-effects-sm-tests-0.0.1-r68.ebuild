# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b376c5b8896081064ba30d64558b97b92b2d15c5"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "e3b92b04b3b4a9c54c71955052636c95b5d2edcd" "8ff600a6ef21c61f20e7de9641247da1095fec13" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "0170c45aa92afbbda70295720a190eb2b8e9e8e1" "af6fc408515c00ee7062ee02ffb95c2814949aad" "7f33489067f631fadbf2083ac7f426bb1a051967" "cca028a152e5133236b2b7dd8b97ca79660968c2" "546d612834bb46518d8ed157a8923c49016e2fb5" "dc8b0e1b6efa5474b3a65150b44150dccf1474c2" "5be17ba0d331df49cda26486f5a3e5d5db8b480a" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "4c5172284b14b531b3792e06b4423c8ca5f888f9" "1df96416290731160d582fa8ffa8f156b2fbac53")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE=".gn common-mk metrics camera/build camera/common camera/features camera/gpu camera/include camera/mojo chromeos-config iioservice/libiioservice_ipc iioservice/mojo ml_core ml_core/mojo"

DESCRIPTION="Tests Effects Stream Manipulator"

PLATFORM_SUBDIR="camera/features/effects/tests"

SRC_URI="gs://chromeos-localmirror/distfiles/ml-core-cros_effects_test_assets-0.0.4.tar.xz"
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
