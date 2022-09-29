# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5346938cf3243cef298eee4719ea9d1f4b8f9f2d"
CROS_WORKON_TREE="8045d6f81d137c82c96d9e8974577828390c54b3"
CROS_WORKON_PROJECT="chromiumos/platform/vboot_reference"
CROS_WORKON_LOCALNAME="platform/vboot_reference"

inherit cros-workon cros-sanitizers

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

src_configure() {
	sanitizers-setup-env
	default
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
