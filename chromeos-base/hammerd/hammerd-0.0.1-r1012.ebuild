# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="442824894a6ac78268b008fd0688b29f83572afa"
CROS_WORKON_TREE=("fa9dbf5f93a6d9bd6d95bedebb827fe6659eebf2" "79db014500c2b49027abff7a5df684c3f2b99a5e" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk hammerd .gn"

PLATFORM_SUBDIR="hammerd"

inherit cros-workon platform user

DESCRIPTION="A daemon to update EC firmware of hammer, the base of the detachable."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hammerd/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-hammerd_api fuzzer"

RDEPEND="
	chromeos-base/ec-utils:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/vboot_reference:=
	dev-libs/openssl:0=
	sys-apps/flashmap:=
"
DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=[fuzzer?]
"

pkg_preinst() {
	# Create user and group for hammerd
	enewuser "hammerd"
	enewgroup "hammerd"
}

src_install() {
	dobin "${OUT}/hammerd"

	# Install upstart configs and scripts.
	insinto /etc/init
	doins init/*.conf
	exeinto /usr/share/cros/init
	doexe init/*.sh

	# Install DBus config.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.hammerd.conf

	# Install rsyslog config.
	insinto /etc/rsyslog.d
	doins rsyslog/rsyslog.hammerd.conf

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/hammerd_load_ec_image_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/hammerd_update_fw_fuzzer
}

platform_pkg_test() {
	platform_test "run" "${OUT}/unittest_runner"
}
