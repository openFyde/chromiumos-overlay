# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="e524d0ce0ceda6e04437a89df7f5d70acb6bbbb3"
CROS_WORKON_TREE="b021d5d4f2e725ef83d99b6ce2ed111494ca4cd4"
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
	chromeos-base/libevdev:=
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
