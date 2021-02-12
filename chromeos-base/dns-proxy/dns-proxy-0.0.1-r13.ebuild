# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f60804253f452eb97cc6e8f18da39cd4f103c422"
CROS_WORKON_TREE=("6aefce87a7cf5e4abd0f0466c5fa211f685a1193" "f46856d8f0247c42343d28e281d69dc4fa1fec44" "00685cdb0fe5933fb11040058f57cd5d17bebd21" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk dns-proxy shill/dbus/client .gn"

PLATFORM_SUBDIR="dns-proxy"

inherit cros-workon platform user

DESCRIPTION="A daemon that provides DNS proxying services."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dns-proxy/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/minijail:=
	chromeos-base/patchpanel:=
	chromeos-base/patchpanel-client:=
	chromeos-base/shill-dbus-client:=
	dev-libs/protobuf:=
	dev-libs/dbus-glib:=
	sys-apps/dbus:=
	net-misc/curl:=
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/permission_broker-client:=
"

pkg_preinst() {
	enewuser "dns-proxy"
	enewgroup "dns-proxy"
}

src_install() {
	dosbin "${OUT}"/dnsproxyd

	insinto /etc/init
	doins init/dns-proxy.conf

	insinto /usr/share/policy
	newins seccomp/dns-proxy-seccomp-"${ARCH}".policy dns-proxy-seccomp.policy
}

platform_pkg_test() {
	platform_test "run" "${OUT}/dns-proxy_test"
}
