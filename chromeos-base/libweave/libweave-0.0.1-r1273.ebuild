# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("9a2de0d377fdae131802e2c260721d2203d78009" "9060831133ffb21d26641018be667b36a449b86a")
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "be6429aaf7e01d2681cb9c8fee7ed73703282382")
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
