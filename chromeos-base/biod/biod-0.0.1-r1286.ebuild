# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="8c4b2c6b54da967bb5cff8b5f5467559aa1027e2"
CROS_WORKON_TREE=("5d76066514dca6a32e833620a997a659f7fb2fd0" "dd43c8ffd2cc59b6cb385135119190b787fe0f03" "470e1be8f15ab9f8c62ffa848f2024ccf2220861" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk biod metrics .gn"

PLATFORM_SUBDIR="biod"

inherit cros-workon platform udev user

DESCRIPTION="Biometrics Daemon for Chromium OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/packages/biod"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/libchrome
	chromeos-base/metrics
	"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api
	"

pkg_setup() {
	enewuser biod
	enewgroup biod
}

src_install() {
	dobin "${OUT}"/biod

	into /usr/local
	dobin "${OUT}"/biod_client_tool
	dobin "${OUT}"/fake_biometric_tool

	insinto /etc/init
	doins init/*.conf

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.BiometricsDaemon.conf

	udev_dorules udev/99-biod.rules

	# Set up cryptohome daemon mount store in daemon's mount
	# namespace.
	local daemon_store="/etc/daemon-store/biod"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners biod:biod "${daemon_store}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/biod_test_runner"
}
