# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="648cf9ab9fb2fad3dccc036482c1b6308e9231c5"
CROS_WORKON_TREE=("cc8ae75ea68e5c37c867b396c0540c8a109ed460" "14a9937adc823905669b1a5884350cb225cc665a" "51982e6e22c5d8777e900497170cc6c5784df5a9" "9d9c4444f2245c4ed1b8b4fd5ce02991060f6943" "359903647899af99fb1bc9ba9d666b0e78fcb3a8" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Remove libmems from this list.
CROS_WORKON_SUBTREE="common-mk chromeos-config iioservice mems_setup libmems .gn"

PLATFORM_SUBDIR="mems_setup"

inherit cros-workon platform udev

DESCRIPTION="MEMS Setup for Chromium OS."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/mems_setup"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="generated_cros_config iioservice unibuild"

COMMON_DEPEND="
	chromeos-base/libmems:=
	net-libs/libiio:=
	unibuild? (
		!generated_cros_config? ( chromeos-base/chromeos-config )
		generated_cros_config? ( chromeos-base/chromeos-config-bsp:= )
	)
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:="

src_install() {
	udev_dorules 99-mems_setup.rules
	dosbin "${OUT}"/mems_setup
}

platform_pkg_test() {
	local tests=(
		mems_setup_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
