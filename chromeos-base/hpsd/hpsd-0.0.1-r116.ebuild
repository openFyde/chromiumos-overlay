# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="91d24f3a2ab509418bcca3e174a3b779744f0afa"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "46d6377f1c607927af66c203ce3cd0469d76fd4e" "f9c9ff0f07a0e5d4015af871a558204de304bb90" "e849dc63a297841f850ba099695224eea2cd48af")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE=".gn hps common-mk metrics"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="hps"

inherit cros-workon platform user

DESCRIPTION="Chrome OS HPS daemon."

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="hpsd-roflash"

RDEPEND="
	hpsd-roflash? ( dev-embedded/stm32flash:= )
"

DEPEND="${RDEPEND}
	chromeos-base/metrics:=
	chromeos-base/system_api:=
	dev-embedded/libftdi:=
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
