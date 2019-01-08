# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="8e636865b877bbb848b56a43d3b1263bf330a16d"
CROS_WORKON_TREE=("6cbd9c184c53df44a2031eda68e398d232e73a6e" "c5dc35abf3a5f051a934c6d0ba22331bee59dd39" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk hammerd .gn"

PLATFORM_SUBDIR="hammerd"

inherit cros-workon platform user

DESCRIPTION="A daemon to update EC firmware of hammer, the base of the detachable."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hammerd/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"
IUSE="-hammerd_api"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/metrics
	chromeos-base/vboot_reference
	dev-libs/openssl
	sys-apps/flashmap
"
DEPEND="
	${RDEPEND}
	chromeos-base/system_api
"

pkg_preinst() {
	# Create user and group for hammerd
	enewuser "hammerd"
	enewgroup "hammerd"
}

src_install() {
	dobin "${OUT}/hammerd"

	# Install upstart configs and scripts.
	insinto /etc/init
	doins init/*.conf
	exeinto /usr/share/cros/init
	doexe init/*.sh

	# Install DBus config.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.hammerd.conf

	# Install rsyslog config.
	insinto /etc/rsyslog.d
	doins rsyslog/rsyslog.hammerd.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
