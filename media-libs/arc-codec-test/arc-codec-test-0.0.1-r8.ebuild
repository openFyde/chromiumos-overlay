# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="ea4848dddea32f8b28e02d8d4fea34cad3ae6d45"
CROS_WORKON_TREE=("5f161815f898131d54bf362fdca25e6a192a2b07" "e220eed9c62e23a855f6b5ebce2310a69a9309a5" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
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
	append-lfs-flags
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

	newexe "${OUT}/arcvideoencoder_test" "arcvideoencoder_test_${ABI}"
}
