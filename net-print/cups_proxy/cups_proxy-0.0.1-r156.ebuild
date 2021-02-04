# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="f94fa4ae6da723e39c479c9414b28f0d2e29d0c4"
CROS_WORKON_TREE=("6aefce87a7cf5e4abd0f0466c5fa211f685a1193" "dbdc344c629475c6ea335c45704d2a1db809165f" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
