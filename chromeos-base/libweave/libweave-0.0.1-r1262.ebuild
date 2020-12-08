# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("6fb68e118050011bb06e525e8d702bfa6ee88b28" "b6a68261d39fd5b3a2295b339d7fe9a7dee5ae6a")
CROS_WORKON_TREE=("ea1c2b11cdf389a2c865c0221f69d6addfe4ded0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "1cd246b1347d6d7eff00f9bef553a06840f12047")
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
	dolib.so "${OUT}"/lib/libweave-"${v}".so
	doins "${OUT}"/lib/libweave-*"${v}".pc
	dolib.a "${OUT}"/libweave-test-"${v}".a

	# Install header files.
	insinto /usr/include/weave/
	doins -r include/weave/*
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libweave_testrunner"
}
