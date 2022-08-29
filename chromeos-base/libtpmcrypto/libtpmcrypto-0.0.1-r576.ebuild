# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d2b3e9755f7df4a98d4769ad85a172b2bd4502fd"
CROS_WORKON_TREE=("9ca78a2d46421d17d297bbb13b05eebbb51d330a" "9b7b73bb2e3daa0653cec8c73a23532c0d32833a" "0b343737ed85a0444890f51bc74376c57ba7fdca" "b90d0e8f789e8cfe86794cb3f36ae69967b7dc36" "138c3678a91a76deabf146933e6d03cb0eba0d7c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation libtpmcrypto trunks .gn"

PLATFORM_SUBDIR="libtpmcrypto"

inherit cros-workon platform

DESCRIPTION="Encrypts/Decrypts data to a serialized proto with TPM sealed key."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/libtpmcrypto/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="tpm tpm_dynamic tpm2"
REQUIRED_USE="
	tpm_dynamic? ( tpm tpm2 )
	!tpm_dynamic? ( ?? ( tpm tpm2 ) )
"

# This depends on protobuf because it uses protoc and needs to be rebuilt
# whenever the protobuf library is updated since generated source files may be
# incompatible across different versions of the protobuf library.
COMMON_DEPEND="
	tpm2? (
		chromeos-base/trunks:=
	)
	tpm? (
		app-crypt/trousers:=
	)
	chromeos-base/libhwsec-foundation:=
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
