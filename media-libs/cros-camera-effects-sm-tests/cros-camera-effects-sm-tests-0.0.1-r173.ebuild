# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="33a8fa386180a5fce9d1ab59a0d2e9a18521f378"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "5b87e97f3ddb9634fb1d975839c28e49503e94f8" "63011a57f0808f474403dbaa6d5c0c093b53f1ce" "67326aa19f1aee5051aefd50a959b82d12643540" "ca09ab791c51e2070cf6459ddd1f82858166c39a" "9fad03618cc0c623614d9cc45597a67cd3f8c212" "56d11be3eee2e1ae4822f70f73b6e8cc7a4082c8" "a55b5c7cb59d379ad7bf9c9da3a168f999f675dc" "42d4c946578d8a8457ffbcc4ce9125341f8f42f1" "d031af9b5360ae0f704f4d6ef23b234fc46152cf" "1e601fb1df98e9ea9f5803aeb50bd6fbec835a2a" "e40ac435946a5417104d844a323350d04e9d3b2e" "530aad55e0d4e774c14ac82608f49886f5de773e")
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
