# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7a7b1dd6e72bf117d45ebce5106d109bda394a4b"
CROS_WORKON_TREE=("3ad7a81ced8374a286e1c564a6e9c929f971a655" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
inherit cros-workon platform git-r3

DESCRIPTION="Intel NNAPI HAL"
HOMEPAGE="https://github.com/intel/nn-hal"

LICENSE="BSD-Google"
KEYWORDS="-* amd64"
IUSE="vendor-nnhal"
RESTRICT="strip"

CROS_WORKON_PROJECT=("chromiumos/platform2")
CROS_WORKON_LOCALNAME=("platform2")
CROS_WORKON_DESTDIR=("${S}/platform2")
CROS_WORKON_SUBTREE=("common-mk .gn")

PLATFORM_SUBDIR="nn-hal"

RDEPEND="
	chromeos-base/aosp-frameworks-ml-nn
	chromeos-base/intel-openvino
"

DEPEND="
	${RDEPEND}
"

src_unpack() {
	platform_src_unpack

	EGIT_REPO_URI="https://github.com/intel/nn-hal.git" \
	EGIT_CHECKOUT_DIR="${S}" \
	EGIT_COMMIT="8596953fb5904214ef770941f2a68633814797ab" \
	EGIT_BRANCH="chromeos-vpu" \
	git-r3_src_unpack

	EGIT_REPO_URI="https://github.com/openvinotoolkit/openvino.git" \
	EGIT_CHECKOUT_DIR="${S}/../intel-openvino-dev" \
	EGIT_COMMIT="2022.3.0" \
	git-r3_src_unpack
}

src_prepare() {
	cros_enable_cxx_exceptions
	eapply_user
}

src_configure() {
	if use x86 || use amd64; then
		append-cppflags "-D_Float16=__fp16"
		append-cxxflags "-Xclang -fnative-half-type"
		append-cxxflags "-Xclang -fnative-half-arguments-and-returns"
	fi
	platform_src_configure
}

src_install() {
	platform_src_install

	if use vendor-nnhal ; then
		einfo "Installing Intel VPU vendor hal."
		dolib.so "${OUT}/lib/libvendor-nn-hal.so"
		dolib.so "${OUT}/lib/libintel_nnhal.so"
	fi
}
