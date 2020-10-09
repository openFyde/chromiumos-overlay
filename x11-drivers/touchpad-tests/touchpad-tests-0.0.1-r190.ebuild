# Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="d289d9fdb0aceb7c6f753806871f68d19211d9af"
CROS_WORKON_TREE="8352ad90ea57e4909e6e8aa48a42aefff863a50b"
CROS_WORKON_PROJECT="chromiumos/platform/touchpad-tests"
CROS_WORKON_LOCALNAME="../platform/touchpad-tests"

inherit cros-workon cros-constants

DESCRIPTION="Chromium OS multitouch driver regression tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/touchpad-tests"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="chromeos-base/gestures
	chromeos-base/libevdev
	app-misc/utouch-evemu
	x11-base/xorg-proto"
DEPEND=${RDEPEND}

src_install() {
	# install to autotest deps directory for dependency
	emake DESTDIR="${D}${AUTOTEST_BASE}/client/deps/touchpad-tests" install
}
