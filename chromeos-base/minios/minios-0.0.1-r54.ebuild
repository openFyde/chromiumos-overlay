# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="fdfa7f1d9f79e53f1c747c89f09450710f0ce037"
CROS_WORKON_TREE=("82ffc96fb6e8d49ae4f8b8988124d565af3be61f" "e9c88e81130f2330573b56632cad10c4b0ab90f5" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	dobin "${OUT}/minios"
	dobin scripts/root_partition_for_recovery

	# D-Bus configuration
	insinto /etc/dbus-1/system.d
	doins org.chromium.MiniOs.conf
	insinto "/build/initramfs"
	doins init/*.conf
}
