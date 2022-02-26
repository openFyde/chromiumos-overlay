# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4b7576c6618d2e386934c69d73d1109b19de6b0c"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "373107fcd9ff3dbb7ab268aebeca33accdf65ed1" "8478dc3bc65690142c4953b004b2724360b349b1" "4a0dedab080195bdc122d2289118df4af3ddca2c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn hps common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="hps"

inherit cros-workon platform udev user

DESCRIPTION="Chrome OS HPS daemon."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="hpsd-roflash"

RDEPEND="
	chromeos-base/metrics:=
	hpsd-roflash? (
		dev-libs/libgpiod
	)
	virtual/libusb:1
"

DEPEND="${RDEPEND}
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewuser "hpsd"
	enewgroup "hpsd"
}

src_install() {
	platform_src_install

	dosbin "${OUT}"/hpsd

	# Install upstart configuration.
	insinto /etc/init
	doins daemon/init/hpsd.conf

	if use hpsd-roflash ; then
		doins daemon/init/hpsd_roflash.conf
	fi

	insinto /etc/dbus-1/system.d
	doins daemon/dbus/org.chromium.Hps.conf

	exeinto "$(get_udevdir)"
	doexe udev/*.sh
	udev_dorules udev/*.rules
}

platform_pkg_test() {
	local tests=(
		dev_test
		hps_test
		hps_metrics_test
		hps_daemon_test
		hps_filter_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test run "${OUT}/${test_bin}"
	done
}
