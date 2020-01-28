# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="47573cc6b18ea22d510a37c28dc19abe7050630d"
CROS_WORKON_TREE=("e27f1b4637c4d92b0c7b14963d2910ad6b0b631e" "9ae30319d3a0781ebc52bf24008565db897d450d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"

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
