# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("04211c61ef8d1f9d680ee9db5b30ad0855f4b99e" "b603f0f3db52cac5feccdf032466f711369f1f37")
CROS_WORKON_TREE=("30d49e96f78c127c17008bafed2c41d759f8abe8" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "9e986de5d4545b24f31f2894d9fd17958add8daa")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME=("platform2" "weave/libweave")
CROS_WORKON_PROJECT=("chromiumos/platform2" "weave/libweave")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/weave/libweave")
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="libweave"
PLATFORM_GYP_FILE="libweave.gyp"

inherit cros-workon libchrome platform

DESCRIPTION="Weave device library"
HOMEPAGE="http://dev.chromium.org/chromium-os/platform"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

# libweave-test, which depends on gmock, is built unconditionally, so the gmock
# dependency is always needed.
DEPEND="dev-cpp/gmock"

src_unpack() {
	local s="${S}"
	platform_src_unpack
	S="${s}/weave/libweave/"
}

src_install() {
	insinto "/usr/$(get_libdir)/pkgconfig"

	# Install libraries.
	local v
	for v in "${LIBCHROME_VERS[@]}"; do
		./preinstall.sh "${OUT}" "${v}"
		dolib.so "${OUT}"/lib/libweave-"${v}".so
		doins "${OUT}"/lib/libweave-*"${v}".pc
		dolib.a "${OUT}"/libweave-test-"${v}".a
	done

	# Install header files.
	insinto /usr/include/weave/
	doins -r include/weave/*
}

platform_pkg_test() {
	platform_test "run" "${OUT}/libweave_testrunner"
}
