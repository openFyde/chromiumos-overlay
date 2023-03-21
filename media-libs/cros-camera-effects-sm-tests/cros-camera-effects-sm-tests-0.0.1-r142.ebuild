# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7b0ebba0e34deadfef168f423dd41639bf1082ba"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "017dc03acde851b56f342d16fdc94a5f332ff42e" "e1f223c8511c80222f764c8768942936a8de01e4" "67326aa19f1aee5051aefd50a959b82d12643540" "942e5bce2836cc95b4dc9b416d02e2fee3435359" "f23c8acad728eee832a0925c3bb48a04f3199fef" "56d11be3eee2e1ae4822f70f73b6e8cc7a4082c8" "a107bda06bdcf45088d2aecf0d50b69804adfd69" "4346f7da65df359f08635a2031a3e6b5036731c1" "ec2c9a2c5033b80cd1d5791abfa91eff20156237" "1e601fb1df98e9ea9f5803aeb50bd6fbec835a2a" "e40ac435946a5417104d844a323350d04e9d3b2e" "3b11fc6ac3a2ed2e40dfa6d862da597b72fd883d")
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE=".gn common-mk metrics camera/build camera/common camera/features camera/gpu camera/include camera/mojo chromeos-config iioservice/libiioservice_ipc iioservice/mojo ml_core ml_core/mojo"

DESCRIPTION="Tests Effects Stream Manipulator"

PLATFORM_SUBDIR="camera/features/effects/tests"

SRC_URI="gs://chromeos-localmirror/distfiles/ml-core-cros_effects_test_assets-0.0.6.tar.xz"
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
