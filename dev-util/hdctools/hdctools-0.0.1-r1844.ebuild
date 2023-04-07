# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="41a0b349a23bcf56ced0e586f1d502378c9dc70d"
CROS_WORKON_TREE="52e4c56d18d32287d39999039fc8f9cbd593a6b6"
CROS_WORKON_PROJECT="chromiumos/third_party/hdctools"
PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon distutils-r1 toolchain-funcs udev cros-sanitizers

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
"

BDEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

src_configure() {
	sanitizers-setup-env
	default
}

src_compile() {
	tc-export CC PKG_CONFIG
	local makeargs=( $(usex cros_host '' EXTRA_DIRS=chromeos) )
	emake "${makeargs[@]}"
	distutils-r1_src_compile
}

src_configure() {
	sanitizers-setup-env
	default
}

src_install() {
	local makeargs=(
		$(usex cros_host '' EXTRA_DIRS=chromeos)
		DESTDIR="${D}"
		LIBDIR="/usr/$(get_libdir)"
		UDEV_DEST="${D}$(get_udevdir)/rules.d"
		install
	)
	emake "${makeargs[@]}"
	distutils-r1_src_install
}
