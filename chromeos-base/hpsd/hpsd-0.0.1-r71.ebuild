# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="873ff642e711a36591cd30344d13a58f40eb1e4c"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "b69483fb422e7e995ede55564ab82bdc405328a8" "a3d79a5641e6cda7da95a9316f5d29998cc84865" "2e70595826ad86b826c299379e82987a3061dc9b")
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
IUSE=""

RDEPEND="
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

	dosbin "${OUT}"/hpsd

	# Install upstart configuration.
	insinto /etc/init
	doins daemon/init/*.conf

	insinto /etc/dbus-1/system.d
	doins daemon/dbus/org.chromium.Hps.conf
}

platform_pkg_test() {
	local tests=(
		dev_test
		hps_test
		hps_metrics_test
		hps_daemon_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test run "${OUT}/${test_bin}"
	done
}
