# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
CROS_WORKON_COMMIT="98eb44e578e3a267aa6fdc5bb006459d7869eb2a"
CROS_WORKON_TREE=("1a376c7538d71e1cb0369e7fac5d1e6930eeaeaa" "c822a9e2e52b9586d6f707d85eae0a27e2633c6c" "db9379caa66f7fd12b24c9cab3ee02b3cfa225ea" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
}

pkg_preinst() {
        enewuser biod
        enewgroup biod
}

platform_pkg_test() {
	platform_test "run" "${OUT}/biod_test_runner"
}
