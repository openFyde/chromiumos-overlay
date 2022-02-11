# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="cf38154dbfd1833fc3a26984637065212c44d45a"
CROS_WORKON_TREE=("2f8a3fd5e0af952f605c8e7b8afa1ecedad683fa" "5b9d882f62559f243699bf7d9606ddb5d9d7d9d8" "0818b141249f8536bd7a7ed36847584f7f10320a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
	enewuser "secanomaly"
	enewgroup "secanomaly"

	cros-workon_pkg_setup
}

src_install() {
	dosbin "${OUT}"/secanomalyd

	# Install Upstart configuration.
	insinto /etc/init
	doins secanomalyd.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/secanomalyd_testrunner"
}
