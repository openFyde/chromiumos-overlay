# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="a872da9e55b44fcaa0f174a63cdee553e2d1a029"
CROS_WORKON_TREE="bd46a1379d20213856a240c3331778a4ae39f609"
CROS_WORKON_PROJECT="chromiumos/platform/ec"
CROS_WORKON_LOCALNAME="platform/ec"
PYTHON_COMPAT=( python2_7 )

inherit cros-workon distutils-r1

DESCRIPTION="Host development utilities for Chromium OS EC"
HOMEPAGE="https://www.chromium.org/chromium-os/ec-development"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="hammerd"

DEPEND="virtual/libusb:1=
	sys-apps/flashmap:=
	"
RDEPEND="
	${DEPEND}
	app-mobilephone/dfu-util
	sys-firmware/servo-firmware
	sys-apps/flashrom
	!<chromeos-base/ec-utils-0.0.1-r6153
	chromeos-base/ec-utils
	>=dev-python/pyusb-1.0.2
	"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	virtual/pkgconfig
	"

set_board() {
	# No need to be board specific, no tools below build code that is
	# EC specific. bds works for forst side compilation.
	export BOARD="bds"
}

src_configure() {
	distutils-r1_src_configure
}

src_compile() {
	tc-export AR CC PKG_CONFIG RANLIB
	# In platform/ec Makefile, it uses "CC" to specify target chipset and
	# "HOSTCC" to compile the utility program because it assumes developers
	# want to run the utility from same host (build machine).
	# In this ebuild file, we only build utility
	# and we may want to build it so it can
	# be executed on target devices (i.e., arm/x86/amd64), not the build
	# host (BUILDCC, amd64). So we need to override HOSTCC by target "CC".
	export HOSTCC="${CC}"
	set_board
	emake utils-host
	# Add usb_updater2 for servo or hammer updates.
	emake -C extra/usb_updater usb_updater2
	if use hammerd; then
		# Add touchpad_updater for TP update on hammer.
		emake -C extra/touchpad_updater touchpad_updater
	fi
	distutils-r1_src_compile
}

src_install() {
	set_board
	dobin "build/${BOARD}/util/stm32mon"
	dobin "build/${BOARD}/util/ec_parse_panicinfo"
	dobin "build/${BOARD}/util/uartupdatetool"
	dobin "build/${BOARD}/util/iteflash"

	# Add usb_updater2 for servo or hammer updates.
	dosbin "extra/usb_updater/usb_updater2"
	if use hammerd; then
		# Add touchpad_updater for TP update on hammer.
		newsbin "extra/touchpad_updater/touchpad_updater" ec_touchpad_updater
	fi

	dobin "util/flash_ec"
	dobin "util/uart_stress_tester.py"
	insinto /usr/share/ec-devutils
	doins util/openocd/*

	distutils-r1_src_install
}
