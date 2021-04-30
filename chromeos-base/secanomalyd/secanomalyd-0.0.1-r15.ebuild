# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9a3ff861a9733294d0d2f17f6a7cdd83bf449eb5"
CROS_WORKON_TREE=("0c3ac991150c21db311300731f54e240235fb7ee" "8a60d6f71b83feb9e6ef043e26238d97d95c0de4" "a8f340c74a69d8eca49ca70b2461942d7a282f3e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk metrics secanomalyd .gn"

PLATFORM_SUBDIR="secanomalyd"

inherit cros-workon platform user

DESCRIPTION="Chrome OS security-anomaly detection daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/secanomalyd/"
LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/metrics:=
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
