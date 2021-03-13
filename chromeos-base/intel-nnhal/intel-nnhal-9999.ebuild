# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT=("chromiumos/platform2")
CROS_WORKON_LOCALNAME=("platform2")
CROS_WORKON_DESTDIR=("${S}/platform2")
CROS_WORKON_SUBTREE=("common-mk .gn")

PLATFORM_SUBDIR="nn-hal"

inherit base cros-workon platform git-r3

DESCRIPTION="Intel NNAPI HAL"
HOMEPAGE="https://github.com/RavirajSitaram/nn-hal"

LICENSE="BSD-Google"
KEYWORDS="-* ~amd64"
IUSE="vendor-nnhal"
RESTRICT="strip"

RDEPEND="
	chromeos-base/aosp-frameworks-ml-nn
	chromeos-base/intel-openvino
	chromeos-base/intel-gnalib
"

DEPEND="
	${RDEPEND}
"

src_unpack() {
	platform_src_unpack

	EGIT_REPO_URI="https://github.com/intel/nn-hal.git" \
	EGIT_CHECKOUT_DIR="${S}" \
	EGIT_COMMIT="74b8df4bd43174f16cac18ce1f19cfaae2a3217e" \
	EGIT_BRANCH="chromeos-gna" \
	git-r3_src_unpack

	EGIT_REPO_URI="https://github.com/openvinotoolkit/openvino.git" \
	EGIT_CHECKOUT_DIR="${S}/../openvino" \
	EGIT_COMMIT="a4a1bff1cc5a6b22f806adac8845d2806772dacd" \
	EGIT_BRANCH="releases/2020/1.chromeos" \
	git-r3_src_unpack
}

src_prepare() {
        eapply "${FILESDIR}/0001-Deinitialize-Runtime-pools.patch"
      	eapply "${FILESDIR}/0002-optimizations-using-TGL.patch"
	cros_enable_cxx_exceptions
	eapply_user
	
}

src_install() {
	if use vendor-nnhal ; then
		einfo "Installing Intel GNA vendor hal."
		dolib.so "${OUT}/lib/libvendor-nn-hal.so"
		dolib.so "${OUT}/lib/libintel_nnhal.so"
	fi
}
