# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="19726b07e7debd843e61c0731381eaa91bc90c8c"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "1404983938f6b07e76e0346cc283f1081dd7a8fa" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "4613f14d427fbd1c24efd1ff11a638670964af27" "fe046b0444b88eae438d30e246eea62ed3afb19e" "7010a5d9405cc702f23ac245cff1c1a7a877ad4e" "40a1c83b03a8d998cc3846a40c3ee320d6c0129f" "a0af00390c3d3c63903578edd1d7c7cb504a8699" "d6819ed74e00aafbee3e7e0524f5a06282d0bebb" "7ddb8f962dd6611aef849f6a4c0ed7268cedb699" "6da0a978ba1edbe645822f82ddb2493d34ecf9f7" "14df0f25e76b1a7ca05b8aa634e5b209e1cd201a" "1df96416290731160d582fa8ffa8f156b2fbac53")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE=".gn common-mk metrics camera/build camera/common camera/features camera/gpu camera/include camera/mojo chromeos-config iioservice/libiioservice_ipc iioservice/mojo ml_core ml_core/mojo"

DESCRIPTION="Tests Effects Stream Manipulator"

PLATFORM_SUBDIR="camera/features/effects/tests"

SRC_URI="gs://chromeos-localmirror/distfiles/ml-core-cros_effects_test_assets-0.0.3.tar.xz"
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
