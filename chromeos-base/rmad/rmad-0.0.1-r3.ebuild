# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="53eb7dac34bd189fa74f7e18f11a939bdfd33a27"
CROS_WORKON_TREE=("a58d199d2c4d0e5da40bb5d453f513f5e2c97ae4" "87ca32bf1845ecee186eb0eaca7f2de92c076f8a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk rmad .gn"

PLATFORM_SUBDIR="rmad"

inherit cros-workon platform user

DESCRIPTION="ChromeOS RMA daemon."
HOMEPAGE=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="
	${RDEPEND}
	chromeos-base/system_api
"

pkg_preinst() {
	# Create user and group for RMA.
	enewuser "rmad"
	enewgroup "rmad"
}

src_install() {
	dosbin "${OUT}/rmad"

	# Install upstart configs and scripts.
	insinto /etc/init
	doins init/*.conf

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Rmad.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.Rmad.service
}

platform_pkg_test() {
	platform_test "run" "${OUT}/rmad_test"
}
