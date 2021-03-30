# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("70ece0ad8d1216a69e9fd9d83bc65c317931edd1" "57cd67d6dcc10b8a01e8b6ddbb4bb9ac5aa7df9a")
CROS_WORKON_TREE=("ae528dee9890ab7346a1fee2e50877007ea3e1c0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "70e41b616360aff5127aa84d4178a52f740bec3b")
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
