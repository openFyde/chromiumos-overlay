# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9a2de0d377fdae131802e2c260721d2203d78009"
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT=("chromiumos/platform2")
CROS_WORKON_LOCALNAME=("platform2")
CROS_WORKON_DESTDIR=("${S}/platform2")
CROS_WORKON_SUBTREE=("common-mk .gn")

PLATFORM_SUBDIR="nn-hal"

inherit base cros-workon platform git-r3

DESCRIPTION="Intel NNAPI HAL"
HOMEPAGE="https://github.com/RavirajSitaram/nn-hal"

LICENSE="BSD-Google"
KEYWORDS="-* amd64"
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

	EGIT_REPO_URI="https://github.com/RavirajSitaram/nn-hal.git" \
	EGIT_CHECKOUT_DIR="${S}" \
	EGIT_COMMIT="56cbf3e949e0e7e910fc45fe33544ec1d425e344" \
	EGIT_BRANCH="optimize-hal" \
	git-r3_src_unpack

	EGIT_REPO_URI="https://github.com/RavirajSitaram/openvino.git" \
	EGIT_CHECKOUT_DIR="${S}/../openvino" \
	EGIT_COMMIT="15c6a9966ef1e2164474d1539c91da60b2f3390a" \
	EGIT_BRANCH="optimized" \
	git-r3_src_unpack
}

src_prepare() {
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
