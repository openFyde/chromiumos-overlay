# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="13dc028e98898187f8a1eec8512dd2d4d2fd5cc4"
CROS_WORKON_TREE="21a366709fa2b761f5f9d2b9baa6b41027adcac3"
CROS_WORKON_PROJECT="chromiumos/third_party/hdctools"
PYTHON_COMPAT=( python2_7 )

inherit cros-workon distutils-r1 toolchain-funcs udev

DESCRIPTION="Software to communicate with servo/miniservo debug boards"
HOMEPAGE="https://www.chromium.org/chromium-os/servo"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host test"

COMMON_DEPEND="
	>=dev-embedded/libftdi-0.18:=
	dev-python/numpy:=[${PYTHON_USEDEP}]
	>=dev-python/pexpect-3.0:=[${PYTHON_USEDEP}]
	dev-python/pyserial:=[${PYTHON_USEDEP}]
	>=dev-python/pyusb-1.0.2:=[${PYTHON_USEDEP}]
	sys-power/uhubctl
	virtual/libusb:1
	chromeos-base/ec-devutils:=[${PYTHON_USEDEP}]
"

RDEPEND="${COMMON_DEPEND}
	virtual/servo-config-dut-usb3:*
"

DEPEND="${COMMON_DEPEND}
	app-text/htmltidy:=
	test? ( dev-python/pytest:=[${PYTHON_USEDEP}] )
"

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

	# TODO(b/173653826): Re-enable when Python 3 is available.
	rm -r "${D}"/etc/bash_completion.d || die
}
