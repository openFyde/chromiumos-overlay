# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8da5794b7f8d4c5b7597effac594ce4664c5545c"
CROS_WORKON_TREE=("36abcf818b30e23dcd5eb99dc81916cb4af6ec56" "615759fe43ff5b578572c5f9b9ac3633d68d3781" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk dlp .gn"

PLATFORM_SUBDIR="dlp"

inherit cros-workon libchrome platform user

DESCRIPTION="A daemon that provides support for Data Leak Prevention restrictions for file accesses."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/dlp/"

LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/minijail:=
	!dev-db/leveldb
	dev-libs/leveldb:=
	dev-libs/protobuf:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=
	sys-apps/dbus:=
"

src_install() {
	dosbin "${OUT}"/dlp

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Dlp.conf

	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.Dlp.service

	insinto /etc/init
	doins init/dlp.conf

	local daemon_store="/etc/daemon-store/dlp"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners dlp:dlp "${daemon_store}"
}

platform_pkg_test() {
	local gtest_filter_user_tests="-*.RunAsRoot*:"
	local gtest_filter_root_tests="*.RunAsRoot*-"

	platform_test "run" "${OUT}/dlp_test" "0" "${gtest_filter_user_tests}"
	platform_test "run" "${OUT}/dlp_test" "1" "${gtest_filter_root_tests}"
}

pkg_setup() {
	enewuser "dlp"
	enewgroup "dlp"
	cros-workon_pkg_setup
}
