# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="4976e32ebaf56e78afff4cf4ec3fc066e20c82a4"
CROS_WORKON_TREE=("2f5486f5d231a8a7920e3033439b1ae644f07f5d" "a3daebe510c822c5d6350008de7ff42e2fa6c8fd" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

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

platform_pkg_test() {
	platform_test "run" "${OUT}/cups_proxy_unittest"
}
