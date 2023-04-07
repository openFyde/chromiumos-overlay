# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0dc0876075e4a086cfecfe0e0ebf20f94424cbf8"
CROS_WORKON_TREE="841ede843e1737213bea51287db9038f357b7f05"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest libchrome cros-sanitizers python-any-r1

DESCRIPTION="Security autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
# Enable autotest by default.
IUSE="+autotest -chromeless_tests -chromeless_tty containers +seccomp selinux"

RDEPEND="
	!<chromeos-base/autotest-tests-0.0.3
"
DEPEND="${RDEPEND}"

IUSE_TESTS="
	+tests_security_NosymfollowMountOption
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"

cros_pre_src_configure_use_sanitizers() {
	sanitizers-setup-env
}
