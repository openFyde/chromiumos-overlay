# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4b4eb59cfb0011afa7ea6b79d6bca62acb8a0606"
CROS_WORKON_TREE=("487d577f0b2a08f0526aabf33ec63115fe32a16c" "1043d75aa0410eda7cadc41470ea1d5cb9b728e0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/libvda_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libvda_fake_unittest"

	platform_fuzzer_test "${OUT}"/libvda_fuzzer
}
