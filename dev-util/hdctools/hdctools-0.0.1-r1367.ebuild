# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="fe39d2ebff01c3cf13e7f9887f873b3c1a1c0ef0"
CROS_WORKON_TREE="cc8695676259fc4b9341c29307327739c1f54a53"
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

src_test() {
	python_test() {
		# TODO(b/173653826): Delete this check once python2 is dropped.
		python_is_python3 || return
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
