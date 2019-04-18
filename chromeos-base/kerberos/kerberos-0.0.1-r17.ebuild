# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="9e3e6f49ddef919792bff8b10e8cbb7d61f7465c"
CROS_WORKON_TREE=("7c2672e7fd88678931ee5c3ebbcc5e20699264c1" "62b1f77f514a5faeb5a2cab1bca8e7590f145401" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk kerberos .gn"

PLATFORM_SUBDIR="kerberos"

inherit cros-workon platform user

DESCRIPTION="Requests and manages Kerberos tickets to enable Kerberos SSO"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/kerberos/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="asan fuzzer"

RDEPEND="
	app-crypt/mit-krb5
	chromeos-base/libbrillo:=[asan?,fuzzer?]
	chromeos-base/minijail
	dev-libs/protobuf:=
	dev-libs/dbus-glib
	sys-apps/dbus
"
DEPEND="
	${RDEPEND}
	chromeos-base/protofiles:=
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewuser "kerberosd"
	enewgroup "kerberosd"
}

src_install() {
	dosbin "${OUT}"/kerberosd
	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/org.chromium.Kerberos.conf
	insinto /etc/init
	doins etc/init/kerberosd.conf
}

platform_pkg_test() {
	local tests=(
		kerberos_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
