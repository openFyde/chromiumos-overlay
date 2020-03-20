# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
CROS_WORKON_COMMIT="47819d2b59598b30f49ca8a76d7477641da638f2"
CROS_WORKON_TREE="3dfe333305808329f3d5b9ee1fe22a27006560f5"
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
	cros-workon_src_configure
	distutils-r1_src_configure
}

src_compile() {
	tc-export AR CC RANLIB
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
