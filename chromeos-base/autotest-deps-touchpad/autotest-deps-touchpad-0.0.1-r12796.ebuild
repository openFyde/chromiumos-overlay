# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="276654efab8b558830ecaddeb7a57c4b116e404d"
CROS_WORKON_TREE="3d91f22e77fa19967b86f5a8c602be4b33847255"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest-deponly python-any-r1

DESCRIPTION="Autotest touchpad deps"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Autotest enabled by default.
IUSE="+autotest"

AUTOTEST_DEPS_LIST="touchpad-tests"
AUTOTEST_CONFIG_LIST=
AUTOTEST_PROFILERS_LIST=

# NOTE: For deps, we need to keep *.a
AUTOTEST_FILE_MASK="*.tar.bz2 *.tbz2 *.tgz *.tar.gz"

# deps/touchpad-tests
RDEPEND="
	x11-drivers/touchpad-tests
	chromeos-base/touch_firmware_test
	chromeos-base/mttools
"

DEPEND="${RDEPEND}"
