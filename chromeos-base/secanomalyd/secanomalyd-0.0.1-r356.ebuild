# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="855248a9bd9678de4f8b2a61eba2349e10289797"
CROS_WORKON_TREE=("f834e7e40228b458c4100226f262117a9d85cdb3" "6df1cbd56008025f75967252b37c51cf894558cb" "9b3d0802d18b4ca02d9434a5d8a80926e796c21d" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
DEPEND="${COMMON_DEPEND}
	chromeos-base/session_manager-client:=
"

pkg_setup() {
	enewuser "secanomaly"
	enewgroup "secanomaly"

	cros-workon_pkg_setup
}

src_install() {
	platform_src_install

	dosbin "${OUT}"/secanomalyd

	# Install Upstart configuration.
	insinto /etc/init
	doins secanomalyd.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/secanomalyd_testrunner"
}
