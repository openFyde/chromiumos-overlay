# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b31a9b728432f39e3e203a157099247d6bb82b33"
CROS_WORKON_TREE=("0d4ecaca2c9246b7d0f0fd9aa952cc67b495b596" "7a9eedd4156039d1c9460351e41b5db9d370ce40" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/libvda .gn"

PLATFORM_SUBDIR="arc/vm/libvda"

inherit cros-workon platform

DESCRIPTION="libvda CrOS video decoding library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/vm/libvda"

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
