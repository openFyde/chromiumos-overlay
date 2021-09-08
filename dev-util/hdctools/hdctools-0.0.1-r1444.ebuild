# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="34525b7756b6083335885c171f1cebcb055840e7"
CROS_WORKON_TREE="8d50684c78af5a9d5f0171ba314cae343048039c"
CROS_WORKON_PROJECT="chromiumos/third_party/hdctools"
PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon distutils-r1 toolchain-funcs udev

DESCRIPTION="Software to communicate with servo/miniservo debug boards"
HOMEPAGE="https://www.chromium.org/chromium-os/servo"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host test"

COMMON_DEPEND="
	>=dev-embedded/libftdi-0.18:=
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pexpect-3.0[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	>=dev-python/pyusb-1.0.2[${PYTHON_USEDEP}]
	sys-power/uhubctl
	virtual/libusb:1=
	chromeos-base/ec-devutils:=[${PYTHON_USEDEP}]
"

RDEPEND="${COMMON_DEPEND}
	virtual/servo-config-dut-usb3:*
"

DEPEND="${COMMON_DEPEND}
	app-text/htmltidy
"

BDEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

src_compile() {
	tc-export CC PKG_CONFIG
	local makeargs=( $(usex cros_host '' EXTRA_DIRS=chromeos) )
	emake "${makeargs[@]}"
	distutils-r1_src_compile
}

python_test() {
	py.test -v build/ || die
}

src_test() {
	distutils-r1_src_test
}

src_install() {
	local makeargs=(
		$(usex cros_host '' EXTRA_DIRS=chromeos)
		DESTDIR="${D}"
		LIBDIR=/usr/$(get_libdir)
		UDEV_DEST="${D}$(get_udevdir)/rules.d"
		install
	)
	emake "${makeargs[@]}"
	distutils-r1_src_install
}
