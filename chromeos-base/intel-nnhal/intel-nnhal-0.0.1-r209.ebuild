# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="35a85995e8aac3d700502064a0649dd1449d3ab1"
CROS_WORKON_TREE=("c7c0905a6b2404597933022decab6f4c5011aaf7" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
inherit base cros-workon platform unpacker

DESCRIPTION="Intel NNAPI HAL"
HOMEPAGE="https://github.com/intel/nn-hal"
NNHAL_GIT_HASH="311f5d1ce6243751a04eee920e353314875f839e"
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

src_configure() {
	if use x86 || use amd64; then
		append-cppflags "-D_Float16=__fp16"
		append-cxxflags "-Xclang -fnative-half-type"
		append-cxxflags "-Xclang -fallow-half-arguments-and-returns"
	fi
	platform_src_configure
}

src_prepare() {
	cros_enable_cxx_exceptions
	eapply_user
}

src_install() {
	platform_src_install

	if use vendor-nnhal ; then
		einfo "Installing Intel GNA vendor hal."
		dolib.so "${OUT}/lib/libvendor-nn-hal.so"
		dolib.so "${OUT}/lib/libintel_nnhal.so"
	fi
}
