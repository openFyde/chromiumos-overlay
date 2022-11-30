# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0ea1d096ea44e5a1f6faf05b946c0658303f702e"
CROS_WORKON_TREE=("7c7d4170b01f9cd05a107c251a378c716ccd9d77" "b351b261a3ee0131687cc28062782f9ef5962817" "a0bb7932b868dd844079bf2e28c9dce347975cb3" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	dosbin "${OUT}"/secanomalyd

	# Install Upstart configuration.
	insinto /etc/init
	doins secanomalyd.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/secanomalyd_testrunner"
}
