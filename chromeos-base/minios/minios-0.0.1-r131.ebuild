# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5bbbe52a139486abcbd802b9bd3f6763dac479b3"
CROS_WORKON_TREE=("ef118ceb3e8ebcc8b8a4ae6577a71d7ad210a722" "4f69265c5fd046808e8caf985fb0bec755a417a7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk minios .gn"

PLATFORM_SUBDIR="minios"

inherit cros-workon platform

DESCRIPTION="The miniOS main logic."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/minios/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="minios"
REQUIRED_USE="minios"

COMMON_DEPEND="
	chromeos-base/shill-client:=
	chromeos-base/update_engine-client:=
	x11-libs/libxkbcommon:=
	x11-misc/xkeyboard-config:=
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

platform_pkg_test() {
	platform_test "run" "${OUT}/minios_test"
}

src_install() {
	into "/build/initramfs"
	dobin "${OUT}/minios"
	dobin scripts/root_partition_for_recovery

	# D-Bus configuration
	insinto "/build/initramfs/etc/dbus-1/system.d"
	doins org.chromium.MiniOs.conf
	insinto "/build/initramfs/etc/init"
	doins init/*.conf
}
