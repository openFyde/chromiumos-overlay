# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="27e629bce33cf4b9adfd72353e7b1205ced202c9"
CROS_WORKON_TREE=("55939c6ae7e4e501ab2d3534ef3c746607fcc2cd" "dea6e080aaf6540d5299aae979e1ef56e12b2b9c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
