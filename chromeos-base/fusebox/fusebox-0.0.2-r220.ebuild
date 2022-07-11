# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="55fe26b58c0a6458f452b79307b61ad101e911ab"
CROS_WORKON_TREE=("02bfff6bead7011dd0b16a3393e99a677d8e4e0e" "0abf9f0d671c32c2f6461f2530f0b2c5708492c7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_SUBTREE="common-mk fusebox .gn"

PLATFORM_SUBDIR="fusebox"

inherit cros-workon platform user

DESCRIPTION="FuseBox service"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/fusebox"

LICENSE="BSD-Google"
KEYWORDS="*"

IUSE="test"

COMMON_DEPEND="
	dev-libs/protobuf:=
	sys-apps/dbus:=
	=sys-fs/fuse-2.9*:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api
"

src_install() {
	dobin "${OUT}"/fusebox

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.FuseBoxReverseService.conf
}

platform_pkg_test() {
	local tests=(fusebox_test)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
