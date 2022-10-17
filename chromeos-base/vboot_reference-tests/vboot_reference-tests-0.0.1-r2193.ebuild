# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="f1a7efc0ed8bcfb88b4d241dfd516a6636672c81"
CROS_WORKON_TREE="e7e5d8b66fb7e1b44f07e39e7dd5ce094a47ac3a"
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
