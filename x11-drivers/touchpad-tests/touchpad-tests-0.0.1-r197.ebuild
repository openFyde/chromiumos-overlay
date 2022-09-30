# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="094c68d21b9d62e429992505cfca3bbb1f874acc"
CROS_WORKON_TREE="a99b0ea4cb05e9c5d6c086a9da84aaf3a00cc4e1"
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
