# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="15a89b22365b0d3c7e60f9bdb8fecae11807ad0f"
CROS_WORKON_TREE=("65178214f5951b1a8cb86ff95dc749e846f149aa" "9d0de47ab67a1ea6ff9ff8413f2cfb25678f5ab3" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/libvda .gn"

PLATFORM_SUBDIR="arc/vm/libvda"

inherit cros-workon platform

DESCRIPTION="libvda CrOS video decoding library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/libvda"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="libvda_test"

COMMON_DEPEND="
	media-libs/minigbm:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api:=
"

src_install() {
	platform_src_install

	dolib.so "${OUT}"/lib/libvda.so
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/obj/arc/vm/libvda/libvda.pc

	local fuzzer_component_id="632502"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/libvda_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libvda_fake_unittest"

	platform_fuzzer_test "${OUT}"/libvda_fuzzer
}
