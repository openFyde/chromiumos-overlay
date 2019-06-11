# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="ee015853b227cf265491bd80ccf096b188490529"
CROS_WORKON_TREE=("17835ffaf041dda6726a21704067f7602a77b1fe" "d87cb5ff2e09552c59213df9c6fdf3f8d5d367d9" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk cups_proxy .gn"

PLATFORM_SUBDIR="cups_proxy"

inherit cros-workon platform user

DESCRIPTION="CUPS Proxy Daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/cups_proxy/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo:=
	net-libs/libmicrohttpd:=
	"

DEPEND="${RDEPEND}
	"

pkg_preinst() {
	enewuser cups-proxy
	enewgroup cups-proxy
}

src_install() {
	dobin "${OUT}"/cups_proxy

	# Install upstart configuration.
	insinto /etc/init
	doins init/*.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/cups_proxy-seccomp-${ARCH}.policy" cups_proxy-seccomp.policy

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.CupsProxyDaemon.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.CupsProxyDaemon.service
}
