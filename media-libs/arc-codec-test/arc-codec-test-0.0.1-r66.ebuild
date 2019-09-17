# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="aa896519b14416d2b3e842e18f6c070eb8b79a0b"
CROS_WORKON_TREE=("203b3e1cdbe17a87f4c26caaaa3c7aab0d03c92e" "6d0a1403799ea9191481152a885383fce1fe4713" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="arc/codec-test common-mk .gn"

WANT_LIBCHROME="no"
PLATFORM_ARC_BUILD="yes"
PLATFORM_SUBDIR="arc/codec-test"

inherit multilib-minimal arc-build cros-workon platform

DESCRIPTION="ARC++ video codec end-to-end test"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/codec-test/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""
DEPEND="
	dev-cpp/arc-gtest
	${RDEPEND}
"

_export_build_variables() {
	# Variables for arc-gtest package.
	export GTEST_CONFIG="${ARC_SYSROOT}/vendor/bin/gtest-config-${ABI}"
	export GTEST_PREFIX="${ARC_SYSROOT}/vendor"
	export GTEST_LIBDIR="${ARC_SYSROOT}/vendor/$(get_libdir)"
}

src_configure() {
	# Use arc-build base class to select the right compiler.
	arc-build-select-clang
	BUILD_DIR="$(cros-workon_get_build_dir)"

	multilib-minimal_src_configure
}

multilib_src_configure() {
	_export_build_variables
	platform_configure
}

src_compile() {
	multilib-minimal_src_compile
}

multilib_src_compile() {
	_export_build_variables
	platform_src_compile
}

multilib_src_install() {
	OUT="${BUILD_DIR}/out/Default"
	exeinto "/usr/libexec/arc-binary-tests"

	newexe "${OUT}/arcvideodecoder_test" "arcvideodecoder_test_${ABI}"
	newexe "${OUT}/arcvideoencoder_test" "arcvideoencoder_test_${ABI}"
}
