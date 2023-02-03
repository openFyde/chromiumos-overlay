# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a025b0bad806ede83d3b715c7fe259c327151cd2"
CROS_WORKON_TREE="0c3fa4171830374d2e88daef62a8ec2128e8dbcf"
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
