# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk cfm/libdfu_notification .gn"

PLATFORM_SUBDIR="cfm/libdfu_notification"

inherit cros-workon platform user

DESCRIPTION="Library to send firmware update notifications to CFM"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"

RDEPEND=""
DEPEND="${RDEPEND}
	chromeos-base/libbrillo
"

src_install() {
	into /
	dolib.so "${OUT}"/lib/libdfu_notification.so

	"${S}"/platform2_preinstall.sh "${PV}" "/usr/include/chromeos" "${OUT}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/libdfu_notification.pc

	insinto /usr/include/chromeos/cfm/libdfu_notification
	doins ./*.h
}

platform_pkg_test() {
	platform_test "run" "${OUT}"/libdfu_notification_test
}
