# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4481e87cb1f0478266277ee28a31db1b8e53e3b6"
CROS_WORKON_TREE=("8a107d83e7e0a12f330005e0cd66720e3d854a2e" "a58f6ac2f8ad93874bc20dc3d721b6df40aff027" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk buffet .gn"

PLATFORM_SUBDIR="buffet"

inherit cros-workon libchrome platform user

DESCRIPTION="Local and cloud communication services for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/buffet/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	chromeos-base/libweave:=
"

RDEPEND="
	${COMMON_DEPEND}
"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/shill-client:=
	chromeos-base/system_api:=
"

pkg_preinst() {
	# Create user and group for buffet.
	enewuser "buffet"
	enewgroup "buffet"
}

src_install() {
	insinto "/usr/$(get_libdir)/pkgconfig"

	dobin "${OUT}"/buffet
	dobin "${OUT}"/buffet_client

	# DBus configuration.
	insinto /etc/dbus-1/system.d
	doins etc/dbus-1/org.chromium.Buffet.conf

	# Upstart script.
	insinto /etc/init
	doins etc/init/buffet.conf
	sed -i 's/\(BUFFET_DISABLE_PRIVET=\).*$/\1true/g' \
		"${ED}"/etc/init/buffet.conf
}

platform_pkg_test() {
	local tests=(
		buffet_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
