# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="442824894a6ac78268b008fd0688b29f83572afa"
CROS_WORKON_TREE=("fa9dbf5f93a6d9bd6d95bedebb827fe6659eebf2" "10591674b2b26637354a70964dc5774ecf7824c7" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk secanomalyd .gn"

PLATFORM_SUBDIR="secanomalyd"

inherit cros-workon platform user

DESCRIPTION="Chrome OS security-anomaly detection daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/secanomalyd/"
LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/vboot_reference:=
"
RDEPEND="${COMMON_DEPEND}
	chromeos-base/minijail:=
"
DEPEND="${COMMON_DEPEND}"

pkg_setup() {
	# TODO(jorgelo): Add these users.
	# enewuser "secanomalyd"
	# enewgroup "secanomalyd"

	cros-workon_pkg_setup
}

src_install() {
	dosbin "${OUT}"/secanomalyd
}

platform_pkg_test() {
	platform_test "run" "${OUT}/secanomalyd_testrunner"
}
