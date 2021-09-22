# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ed59b70954562ac825be9bbdfef4463e3d37df26"
CROS_WORKON_TREE=("a3d79a5641e6cda7da95a9316f5d29998cc84865" "55e9a8aece508bead4b719092132d0dfcd0f2cad" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	sys-fs/fuse:=
	sys-libs/libcap:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api
"

src_install() {
	dobin "${OUT}"/fusebox
}

platform_pkg_test() {
	local tests=(fusebox_test)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
