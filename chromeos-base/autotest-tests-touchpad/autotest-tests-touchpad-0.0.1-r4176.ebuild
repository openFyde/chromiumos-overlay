# Copyright 2013 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="8333412a9b5f88561f298edb61e586b2ea248ca6"
CROS_WORKON_TREE="3b6497abd42cffa9fb1fab2f76925fae42839b39"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"

inherit cros-workon autotest python-any-r1

DESCRIPTION="touchpad autotest"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="${IUSE} +autotest"

RDEPEND="
	chromeos-base/autotest-deps-touchpad
"

DEPEND="${RDEPEND}"

IUSE_TESTS="
	+tests_platform_GesturesRegressionTest
"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_LOCALNAME="third_party/autotest/files"

AUTOTEST_DEPS_LIST=""
AUTOTEST_CONFIG_LIST=""
AUTOTEST_PROFILERS_LIST=""

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
