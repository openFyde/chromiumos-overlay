# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="909168ac73cca20fb6be1061a75bd6f1ca1ef3b8"
CROS_WORKON_TREE=("986ae0adb1a5ce20599ecc5274e85ef908862acd" "53ef2ebfa021097d072b763a96c27ce70c3e4070" "a969b013416141c4285935b48871273148921d14" "ee938dc15cb94a469f8f4fe353fa98e86edf25b8" "057fb02b88ed4d0008ac7a996aedca04f24541e1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
