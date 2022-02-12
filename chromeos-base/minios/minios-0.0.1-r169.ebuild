# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4747de71f323e545b26b5057f788b5b7b072083d"
CROS_WORKON_TREE=("ba51cdbc1f93611f21a434aa8577a98ed1e9d5f8" "7dbb54592f1dadb985c773aeec05a36323703d2f" "513532ae8c5f4f96de9e9c16f8efbba2c1c58df0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk metrics minios .gn"

PLATFORM_SUBDIR="minios"

inherit cros-workon platform

DESCRIPTION="The miniOS main logic."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/minios/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="minios"
REQUIRED_USE="minios"

COMMON_DEPEND="
	chromeos-base/metrics:=
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
	dobin scripts/stateful_partition_for_recovery

	# D-Bus configuration
	insinto "/build/initramfs/etc/dbus-1/system.d"
	doins org.chromium.MiniOs.conf
	insinto "/build/initramfs/"
	doins -r ramfs/*
}
