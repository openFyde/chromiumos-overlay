# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("069f2a92133ad5b96ec25ee8c150344666b7ebad" "e296a5e3a2fb32cc5dce19114caf5be3e9ba079e")
CROS_WORKON_TREE=("3203fc5c38912e1d0625e33126a801b6ae1a0c59" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c" "3b2da1929dc1b0edb3161e0262441991536f3c79")
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
