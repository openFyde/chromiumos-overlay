# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT=("aa87ba1a4b38be2ffb16f363e76f0f0fe2eb61bc" "ae26ad8516036774fd3b6e84a98a89955dcf5f61")
CROS_WORKON_TREE=("c5e851c0a9f693b39a3385a86e1075e6de1ce2e9" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "1cd0c980789295336eeb6be130bf3f001344f5da")
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

	fuzzer_install "${S}/OWNERS.fuzzer" "${OUT}"/modp_b64_decode_fuzzer
	fuzzer_install "${S}/OWNERS.fuzzer" "${OUT}"/modp_b64_encode_fuzzer
}
