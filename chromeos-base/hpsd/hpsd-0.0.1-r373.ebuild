# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="01611cc312c9b3acec36920032731ee8be032d07"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "9dc908ae84607593f3d65f782e9dfb4ac97e8cd8" "bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "eb510d666a66e6125e281499b649651b849a25f7")
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

RDEPEND="
	chromeos-base/metrics:=
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
