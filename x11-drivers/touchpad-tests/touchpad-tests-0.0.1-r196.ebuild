# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="8a39863b5b733f5e97bc8bd21d8394af6773e247"
CROS_WORKON_TREE="58a499f26417c8d1b82a14cf0604f5c31ce3422b"
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
	chromeos-base/libevdev:=
	app-misc/utouch-evemu
	x11-base/xorg-proto"
DEPEND=${RDEPEND}

src_install() {
	# install to autotest deps directory for dependency
	emake DESTDIR="${D}${AUTOTEST_BASE}/client/deps/touchpad-tests" install
}
