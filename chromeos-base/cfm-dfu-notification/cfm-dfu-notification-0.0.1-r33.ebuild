# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="c142078820d0707858873cedb290a78d36f531af"
CROS_WORKON_TREE=("eec5ce9cfadd268344b02efdbec7465fbc391a9e" "30d44bb1fc4101536954f9209992b13ce5f5a584" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="common-mk cfm-dfu-notification .gn"
CROS_WORKON_DESTDIR="${S}/platform2"

PLATFORM_SUBDIR="cfm-dfu-notification"

inherit cros-workon platform

DESCRIPTION="Library to send firmware update notifications to CFM"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	dolib.so "${OUT}"/lib/libcfm_dfu_notification.so

	"${S}"/platform2_preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/cfm-dfu-notification.pc

	insinto "/usr/include/chromeos/cfm-dfu-notification"
	doins ./*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}"/cfm_dfu_notification_test
}
