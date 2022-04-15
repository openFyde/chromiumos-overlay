# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6e9a5d8a919e78dd46e34df1b92841fa51cdbd37"
CROS_WORKON_TREE=("be0561582cec761c3be2d8ca3ac2b966901b7d58" "ede42b807abb82a814571bea891d23fc48c07e07" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
