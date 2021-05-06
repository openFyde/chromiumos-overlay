# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="710521e036aaed2f2f47caac43179936eca51d25"
CROS_WORKON_TREE=("0c3ac991150c21db311300731f54e240235fb7ee" "7d91fe7fb77f6e0207400a49266811e49aa5a9b9" "24747e1d3a4ebe90b309094916c0ed326d3755ab" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
