# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f0638e0c63344c3f7771f1cfdb2631f15c32158c"
CROS_WORKON_TREE="a34d710ea6825b98d5cbf6059d63e93198d4a596"
CROS_WORKON_PROJECT="chromiumos/platform/vboot_reference"
CROS_WORKON_LOCALNAME="platform/vboot_reference"

inherit cros-workon

DESCRIPTION="vboot tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/"
LICENSE="BSD-Google"
KEYWORDS="*"

COMMON_DEPEND="dev-libs/libzip:=
	dev-libs/openssl:=
	sys-apps/flashrom:=
	sys-apps/util-linux:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

get_build_dir() {
	echo "${S}/build-main"
}

src_compile() {
	mkdir "$(get_build_dir)"
	tc-export CC AR CXX PKG_CONFIG
	# vboot_reference knows the flags to use
	unset CFLAGS
	emake BUILD="$(get_build_dir)" tests
}

src_install() {
	emake BUILD="$(get_build_dir)" DESTDIR="${D}" install_dut_test
}
