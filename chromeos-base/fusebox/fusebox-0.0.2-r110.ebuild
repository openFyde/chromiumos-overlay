# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b09db4624c263c90c90b94841d0027d5a9251b23"
CROS_WORKON_TREE=("e5822571db2e92a58bc12dacc8e5042494372d19" "3dcec10544e03b958eb2ad92fc17e8f4b405d9c1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	doins dbus/org.chromium.FuseBoxService.conf dbus/org.chromium.FuseBoxClient.conf
}

platform_pkg_test() {
	local tests=(fusebox_test)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
