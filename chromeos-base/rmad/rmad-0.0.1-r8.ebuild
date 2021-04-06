# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3d5e8920957da2eaf651088d40b073b2b8f127e5"
CROS_WORKON_TREE=("ae528dee9890ab7346a1fee2e50877007ea3e1c0" "74a0b77cae75bc2f051987b16c691da503037d47" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
