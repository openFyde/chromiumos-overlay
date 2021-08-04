# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e5c6cd634fdc0dbaac47e376c3cb53c417acb7df"
CROS_WORKON_TREE=("d9c21c3b0f24d480773fdba553eb9db4ee252072" "fc282a62a1ea54dffdb482a1c0bbf8a201f2fcf9" "ab15e0a613325b2bb7ee2da9014d5fc0f5d7f02a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk permission_broker webserver .gn"

PLATFORM_SUBDIR="webserver"

inherit cros-workon platform user

DESCRIPTION="HTTP sever interface library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/webserver/"
LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	chromeos-base/permission_broker:=
	net-libs/libmicrohttpd:=
	!chromeos-base/libwebserv:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/permission_broker-client:=
"

pkg_preinst() {
	# Create user and group for webservd.
	enewuser "webservd"
	enewgroup "webservd"
}

src_install() {
	insinto "/usr/$(get_libdir)/pkgconfig"
	local v="$(libchrome_ver)"
	libwebserv/preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}/lib/libwebserv.so"
	doins "${OUT}/lib/libwebserv.pc"

	# Install header files from libwebserv
	insinto /usr/include/libwebserv
	doins libwebserv/*.h

	# Install init scripts for webservd.
	insinto /etc/init
	doins webservd/etc/init/webservd.conf

	# Install DBus configuration files.
	insinto /etc/dbus-1/system.d
	doins webservd/etc/dbus-1/org.chromium.WebServer.conf

	# Install seccomp filter for webservd.
	insinto /usr/share/filters
	doins webservd/usr/share/filters/webservd-seccomp.policy

	# Install web server daemon.
	dobin "${OUT}"/webservd
}

platform_pkg_test() {
	local tests=(
		libwebserv_testrunner
		webservd_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
