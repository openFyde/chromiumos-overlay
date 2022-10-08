# Copyright 2015 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT=("85b14a06205ad4309c718357829421bc4706d018" "269b6fb8401617b85e2dff7ae8a7b0f97613e2cd")
CROS_WORKON_TREE=("4b7854d72e018cacbb3455cf56f41cee31c70fc1" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "9473949bc842cc166ac244567638b94150a97865")
inherit cros-constants

CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/modp_b64")
CROS_WORKON_LOCALNAME=("../platform2" "../third_party/modp_b64")
CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/external/modp_b64")
CROS_WORKON_SUBTREE=("common-mk .gn" "")
CROS_WORKON_EGIT_BRANCH="master"

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

	local fuzzer_component_id="1034879"
	fuzzer_install "${S}/OWNERS.fuzzer" "${OUT}"/modp_b64_decode_fuzzer \
		--comp "${fuzzer_component_id}"
	fuzzer_install "${S}/OWNERS.fuzzer" "${OUT}"/modp_b64_encode_fuzzer \
		--comp "${fuzzer_component_id}"
}
