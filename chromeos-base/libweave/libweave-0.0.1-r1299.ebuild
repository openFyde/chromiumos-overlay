# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("4b4eb59cfb0011afa7ea6b79d6bca62acb8a0606" "0ec98092919a07d24987f0b9ca8c2644a2f7568d")
CROS_WORKON_TREE=("487d577f0b2a08f0526aabf33ec63115fe32a16c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "efd3853b5f7c6fa64994bb69c95783531b58c240")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME=("platform2" "weave/libweave")
CROS_WORKON_PROJECT=("chromiumos/platform2" "weave/libweave")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/libweave")
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="libweave"

inherit cros-workon libchrome platform

DESCRIPTION="Weave device library"
HOMEPAGE="http://dev.chromium.org/chromium-os/platform"
LICENSE="BSD-Google"
KEYWORDS="*"

# libweave-test, which depends on gmock, is built unconditionally, so the gmock
# dependency is always needed.
DEPEND="dev-cpp/gtest:="

src_install() {
	insinto "/usr/$(get_libdir)/pkgconfig"

	# Install libraries.
	local v="$(libchrome_ver)"
	./preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}"/lib/libweave.so
	doins "${OUT}"/lib/libweave{,-test}.pc
	dolib.a "${OUT}"/libweave-test.a

	# Install header files.
	insinto /usr/include/weave/
	doins -r include/weave/*
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libweave_testrunner"
}
