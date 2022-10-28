# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b8d03e8180e86ef9090f91991a96c6b68cb4aad0"
CROS_WORKON_TREE="772f201fdbe781acd3185e044c9e6310ab36caa1"
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
