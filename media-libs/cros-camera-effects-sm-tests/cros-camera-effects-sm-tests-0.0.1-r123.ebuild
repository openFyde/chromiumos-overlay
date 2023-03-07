# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="11a92a3e1785c92cba2e0a2eb131d697d9afc7fc"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "3f8a9a04e17758df936e248583cfb92fc484e24c" "e1f223c8511c80222f764c8768942936a8de01e4" "2ad8679ea3a8f3e8a2509b4b05585f22f2dc373b" "d3cdf6e1d3413a597340657946af477bcefb531d" "9cb6d2ed7e46c29dc84445bbf434dd58fb0fc69a" "f350915f69eba67849197cce3901bc104da7121a" "14f00dcafbef98a768f7f7be17cb697ac12dc529" "2ae3f5c18c4a966b50d7defcd4e5ecfc5d40d1d9" "8919992a60b95f3997cfaf0820df7c0d80664f64" "5be17ba0d331df49cda26486f5a3e5d5db8b480a" "e40ac435946a5417104d844a323350d04e9d3b2e" "487c9debc972e47326f13a8aacbe606e28287a47")
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
