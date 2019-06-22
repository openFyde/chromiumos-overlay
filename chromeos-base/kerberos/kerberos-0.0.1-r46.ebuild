# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="727e4d3faeb0b13631d3fed1724c8eb03e7e1c7c"
CROS_WORKON_TREE=("88964300c225b7e8a3c2fe47860d091ca1f4fb65" "30f1db52b8dde22d7facc93e044a3445504e7a84" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
	chromeos-base/session_manager-client
	chromeos-base/system_api:=
"

pkg_setup() {
	# Has to be done in pkg_setup() instead of pkg_preinst() since
	# src_install() needs kerberosd.
	enewuser kerberosd
	enewgroup kerberosd
	enewuser kerberosd-exec
	enewgroup kerberosd-exec
	cros-workon_pkg_setup
}

src_install() {
	dosbin "${OUT}"/kerberosd
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Kerberos.conf
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.Kerberos.service
	insinto /etc/init
	doins init/kerberosd.conf

	# Create daemon store folder prototype, see
	# https://chromium.googlesource.com/chromiumos/docs/+/master/sandboxing.md#securely-mounting-cryptohome-daemon-store-folders
	local daemon_store="/etc/daemon-store/kerberosd"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners kerberosd:kerberosd "${daemon_store}"
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
