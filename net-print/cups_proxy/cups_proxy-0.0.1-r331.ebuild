# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="f76957fa469f8af582649807981fb592f0ba1d10"
CROS_WORKON_TREE=("db382a13f6e22c79a09ffb69ca5a504dcf6c9bd5" "7b0ea4ad0dd55c624cbdc60df9bfaeea9b2481a6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk cups_proxy .gn"

PLATFORM_SUBDIR="cups_proxy"

inherit tmpfiles cros-workon platform user

DESCRIPTION="CUPS Proxy Daemon for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/cups_proxy/"

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

	dotmpfiles tmpfiles.d/*.conf

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
