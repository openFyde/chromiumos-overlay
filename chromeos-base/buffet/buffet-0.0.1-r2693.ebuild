# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="8c4b2c6b54da967bb5cff8b5f5467559aa1027e2"
CROS_WORKON_TREE=("5d76066514dca6a32e833620a997a659f7fb2fd0" "9497e74352fff1e2b361dd89d743999dc8aec806" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk buffet .gn"

PLATFORM_SUBDIR="buffet"

inherit cros-workon libchrome platform user

DESCRIPTION="Local and cloud communication services for Chromium OS"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	chromeos-base/libbrillo
	chromeos-base/libweave
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/shill-client
	chromeos-base/system_api
"

pkg_preinst() {
	# Create user and group for buffet.
	enewuser "buffet"
	enewgroup "buffet"
}

src_install() {
	insinto "/usr/$(get_libdir)/pkgconfig"

	dobin "${OUT}"/buffet
	dobin "${OUT}"/buffet_client

	# DBus configuration.
	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/org.chromium.Buffet.conf

	# Upstart script.
	insinto /etc/init
	doins etc/init/buffet.conf
	sed -i 's/\(BUFFET_DISABLE_PRIVET=\).*$/\1true/g' \
		"${ED}"/etc/init/buffet.conf
}

platform_pkg_test() {
	local tests=(
		buffet_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
