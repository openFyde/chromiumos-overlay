# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="b414a92cdef7819ce08a47b8c98f99aefeb820ec"
CROS_WORKON_TREE="a91f7936e196d8a275eaba1f3f1395e0ebb3d954"
CROS_WORKON_PROJECT="chromiumos/platform/mttools"
CROS_WORKON_LOCALNAME="platform/mttools"

inherit cros-sanitizers cros-workon cros-common.mk cros-constants cros-debug

DESCRIPTION="Chromium OS multitouch utilities"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/mttools"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"
# This package has no tests.
RESTRICT="test"

RDEPEND="chromeos-base/gestures
	app-misc/utouch-evemu
	chromeos-base/libevdev
	chromeos-base/touch_firmware_test"

DEPEND=${RDEPEND}

src_configure() {
	sanitizers-setup-env
	cros-common.mk_src_configure
}

src_install() {
	# install to autotest deps directory for dependency
	emake DESTDIR="${D}${AUTOTEST_BASE}/client/deps/touchpad-tests/framework" install
}
