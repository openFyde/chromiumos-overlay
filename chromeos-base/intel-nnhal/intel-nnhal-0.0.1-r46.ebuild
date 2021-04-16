# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="97ca3b91ac3374fb81407dfa6b47f6f78b2f2dbf"
CROS_WORKON_TREE=("c9472e5bf2ef861a0c3b602fb4ae3084a5d96ee8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
inherit base cros-workon platform unpacker

DESCRIPTION="Intel NNAPI HAL"
HOMEPAGE="https://github.com/RavirajSitaram/nn-hal"
NNHAL_GIT_HASH="74b8df4bd43174f16cac18ce1f19cfaae2a3217e"
NNHAL_GIT_SHORT_HASH=${NNHAL_GIT_HASH::8}
OPENVINO_GIT_HASH="a4a1bff1cc5a6b22f806adac8845d2806772dacd"
OPENVINO_GIT_SHORT_HASH=${OPENVINO_GIT_HASH::8}
SRC_URI="
	https://github.com/intel/nn-hal/archive/${NNHAL_GIT_HASH}.tar.gz -> intel-nn-hal-${NNHAL_GIT_SHORT_HASH}.tar.gz
	https://github.com/openvinotoolkit/openvino/archive/${OPENVINO_GIT_HASH}.tar.xz -> intel-openvino-${OPENVINO_GIT_SHORT_HASH}.tar.xz
"


LICENSE="BSD-Google"
KEYWORDS="-* amd64"
IUSE="vendor-nnhal"
RESTRICT="strip"

CROS_WORKON_PROJECT=("chromiumos/platform2")
CROS_WORKON_LOCALNAME=("platform2")
CROS_WORKON_DESTDIR=("${S}/platform2")
CROS_WORKON_SUBTREE=("common-mk .gn")

PLATFORM_SUBDIR="nn-hal-${NNHAL_GIT_HASH}"

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

	# Need to unpack the SRC_URI's into the platform2 dir
	cd "${WORKDIR}/${PN}-${PV}/platform2"
	unpacker_src_unpack
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
