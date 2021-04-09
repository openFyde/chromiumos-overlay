# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT=("e2c31be2c6dea118b5f77bc9ec1f4f470abdf6e2" "269b6fb8401617b85e2dff7ae8a7b0f97613e2cd")
CROS_WORKON_TREE=("a54d2df3e8853d5a5f1e0854b36d8d850db3611e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "9473949bc842cc166ac244567638b94150a97865")
inherit cros-constants

CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/modp_b64")
CROS_WORKON_LOCALNAME=("../platform2" "../third_party/modp_b64")
CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/external/modp_b64")
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="modp_b64"

WANT_LIBCHROME=no

inherit cros-fuzzer cros-sanitizers cros-workon platform

DESCRIPTION="Base64 encoder/decoder library."
HOMEPAGE="https://github.com/client9/stringencoders"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="fuzzer"

src_install() {
	dolib.a "${OUT}"/libmodp_b64.a

	insinto /usr/include
	doins -r modp_b64

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}/obj/modp_b64/libmodp_b64.pc"

	fuzzer_install "${S}/OWNERS.fuzzer" "${OUT}"/modp_b64_decode_fuzzer
	fuzzer_install "${S}/OWNERS.fuzzer" "${OUT}"/modp_b64_encode_fuzzer
}
