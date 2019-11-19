# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="b03a3f9856f6bceacaa01919127aa3ebe6c81874"
CROS_WORKON_TREE="5b3d6b87818ff1a8cd48d117b63ce7a96ea75b04"
CROS_WORKON_PROJECT="chromiumos/third_party/hdctools"
PYTHON_COMPAT=( python2_7 )

inherit cros-workon distutils-r1 toolchain-funcs multilib udev

DESCRIPTION="Software to communicate with servo/miniservo debug boards"
HOMEPAGE="https://www.chromium.org/chromium-os/servo"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host test"

RDEPEND=">=dev-embedded/libftdi-0.18
	dev-python/numpy
	>=dev-python/pexpect-3.0
	dev-python/pyserial
	test? ( dev-python/pytest )
	>=dev-python/pyusb-1.0.2
	virtual/libusb:1
	app-misc/screen
	chromeos-base/ec-devutils"
DEPEND="${RDEPEND}
	app-text/htmltidy"

src_configure() {
	cros-workon_src_configure
}

src_test() {
	python_test() {
		py.test -v build/ || die
	}
	python_foreach_impl python_test
}

src_compile() {
	tc-export CC PKG_CONFIG
	local makeargs=( $(usex cros_host '' EXTRA_DIRS=chromeos) )
	emake "${makeargs[@]}"
	distutils-r1_src_compile
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
