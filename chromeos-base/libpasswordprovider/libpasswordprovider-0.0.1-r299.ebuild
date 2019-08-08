# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="8bd1042f66b665c37ca24cec2f7c0908bff56a5f"
CROS_WORKON_TREE=("ce312a57a100a69f5e2d0f8f445e1f6c7604fc95" "c73e1f37fdaafa35e9ffaf067aca34722c2144cd" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libpasswordprovider .gn"

PLATFORM_SUBDIR="libpasswordprovider"

inherit cros-workon platform

DESCRIPTION="Library for storing and retrieving user password"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libpasswordprovider"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo
	sys-apps/keyutils
"

DEPEND="${RDEPEND}"

src_install() {
	dolib.so "${OUT}/lib/libpasswordprovider.so"

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins libpasswordprovider.pc

	insinto "/usr/include/libpasswordprovider"
	doins *.h
}

platform_pkg_test() {

	platform_test "run" "${OUT}/${test_bin}" "0" "${gtest_filter}"
}

platform_pkg_test() {
	local gtest_filter=""
	if ! use x86 && ! use amd64 ; then
		# PasswordProvider tests fail on qemu due to unsupported system calls to keyrings.
		# Run only the Password unit tests on qemu since keyrings are not supported yet.
		# https://crbug.com/792699
		einfo "Skipping PasswordProvider unit tests on non-x86 platform"
		gtest_filter+="Password.*"
	fi

	local tests=(
		password_provider_test
	)

	local test_bin
		for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}" 0 "${gtest_filter}"
	done
}
