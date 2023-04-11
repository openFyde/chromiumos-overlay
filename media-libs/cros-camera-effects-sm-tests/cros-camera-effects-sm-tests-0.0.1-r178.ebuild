# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="91181e7f74a369f51c79b13422c2a08b8590e6f9"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "e44d7e66ab4ccaab888a42ade972724af9621706" "70d4a8ca946d6d0adf038d9afbdb57027e9887f7" "67326aa19f1aee5051aefd50a959b82d12643540" "f95a8c6f6415e4118a8ca857cc7b19ee75bde542" "9fad03618cc0c623614d9cc45597a67cd3f8c212" "56d11be3eee2e1ae4822f70f73b6e8cc7a4082c8" "8382512685d679dd033d07c31295df8160820113" "42d4c946578d8a8457ffbcc4ce9125341f8f42f1" "6d3b76b402ee2ad0e719b1b1242c3e797c19d2e1" "1e601fb1df98e9ea9f5803aeb50bd6fbec835a2a" "e40ac435946a5417104d844a323350d04e9d3b2e" "530aad55e0d4e774c14ac82608f49886f5de773e")
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
