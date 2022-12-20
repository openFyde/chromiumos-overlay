# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2024c47f3cea15401fe53a34e6140993777bcbcb"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "66103fa54350371c16815b131ef3625b207e0eb9" "0c3a30cd50ce72094fbd880f2d16d449139646a2" "8d856cb1fd8b7169075c5ae9c9a1ed9d4b8cbd6b")
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
