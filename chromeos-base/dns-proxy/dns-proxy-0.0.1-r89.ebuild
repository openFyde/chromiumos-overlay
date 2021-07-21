# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bba01f8fa834e96c4dee4e67c662f215d706b55f"
CROS_WORKON_TREE=("cc8ae75ea68e5c37c867b396c0540c8a109ed460" "e238f3631ad2969309dbb9115dea90bd224abb71" "c6491a3e3692d915bc2409534fa3cdef384c7795" "e7e19d7248ee208203b22104118a2d06554c9896" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk dns-proxy metrics shill/dbus/client .gn"

PLATFORM_SUBDIR="dns-proxy"

inherit cros-workon platform user

DESCRIPTION="A daemon that provides DNS proxying services."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dns-proxy/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/metrics:=
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

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/ares_client_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/doh_curl_client_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/resolver_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/dns-proxy_test"
}
