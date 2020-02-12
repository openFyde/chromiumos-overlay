# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="942284d9836605cf9f112590c729137abdd47e56"
CROS_WORKON_TREE=("142f8e8618a85124529b0000717d72079aa4ad97" "224d4a1f5a9f36390178a03ab97c1ee3d69854db" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk system-proxy .gn"

PLATFORM_SUBDIR="system-proxy"

inherit cros-workon platform

DESCRIPTION="A daemon that provides authentication support for system services
and ARC apps behind an authenticated web proxy."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/system-proxy/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
	chromeos-base/minijail:=
	dev-libs/protobuf:=
	dev-libs/dbus-glib:=
	sys-apps/dbus:=
	net-misc/curl:=
"
DEPEND="
	${RDEPEND}
"

pkg_preinst() {
	enewuser "system-proxy"
	enewgroup "system-proxy"
}

src_install() {
	dosbin "${OUT}"/system_proxy
	dosbin "${OUT}"/system_proxy_worker

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.SystemProxy.conf

	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.SystemProxy.service

	insinto /etc/init
	doins init/system-proxy.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/system-proxy_test"
}
