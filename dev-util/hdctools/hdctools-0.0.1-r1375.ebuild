# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="af4b92a5074f92dbc2b6789b6dfeee7ee9051fdd"
CROS_WORKON_TREE="aa9d63623537e0734e7b5b74bb0e1ed3ef189c41"
CROS_WORKON_PROJECT="chromiumos/third_party/hdctools"
PYTHON_COMPAT=( python{2_7,3_{6..9}} )

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

# TODO(b/173653826): Re-add PYTHON_USEDEP once python2 is dropped.
BDEPEND="test? ( dev-python/pytest )"

python_compile() {
	# TODO(b/173653826): Delete this check once python2 is dropped.
	if ! python_is_python3; then
		rm build/servo/data/data_integrity_test.py || die
	fi
	distutils-r1_python_compile
	if ! python_is_python3; then
		cp servo/data/data_integrity_test.py build/servo/data/data_integrity_test.py || die
	fi
}

src_compile() {
	tc-export CC PKG_CONFIG
	local makeargs=( $(usex cros_host '' EXTRA_DIRS=chromeos) )
	emake "${makeargs[@]}"
	distutils-r1_src_compile
}

python_test() {
	# TODO(b/173653826): Delete this check once python2 is dropped.
	python_is_python3 || return
	py.test -v build/ || die
}

src_test() {
	distutils-r1_src_test
}

python_install() {
	# TODO(b/173653826): Delete this check once python2 is dropped.
	if ! python_is_python3; then
		rm build/servo/data/data_integrity_test.py || die
	fi
	distutils-r1_python_install
	if ! python_is_python3; then
		cp servo/data/data_integrity_test.py build/servo/data/data_integrity_test.py || die
	fi
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
