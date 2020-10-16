# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c8222960422eb2bc872a727b170a6a9941a01354"
CROS_WORKON_TREE=("dd4323fe3640909500f29f7acde8c0868024c48a" "d8479ac4f3bc0cc18815ff1d440dc3abd761db42" "b4c91bd8531e62cea50ef9ca4369fffaed3239fe" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libtpmcrypto trunks .gn"

PLATFORM_SUBDIR="libtpmcrypto"

inherit cros-workon platform

DESCRIPTION="Encrypts/Decrypts data to a serialized proto with TPM sealed key."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libtpmcrypto/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="tpm tpm2"
REQUIRED_USE="tpm2? ( !tpm )"

# This depends on protobuf because it uses protoc and needs to be rebuilt
# whenever the protobuf library is updated since generated source files may be
# incompatible across different versions of the protobuf library.
COMMON_DEPEND="
	tpm2? (
		chromeos-base/trunks:=
	)
	!tpm2? (
		app-crypt/trousers:=
	)
	dev-libs/protobuf:=
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
"

src_install() {
	dolib.so "${OUT}/lib/libtpmcrypto.so"

	"${S}"/platform2_preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}/libtpmcrypto.pc"

	insinto "/usr/include/libtpmcrypto"
	doins *.h
}

platform_pkg_test() {
	local tests=(
		tpmcrypto_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
