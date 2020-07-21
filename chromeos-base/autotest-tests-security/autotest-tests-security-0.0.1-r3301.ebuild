# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="1201b78e4fc42507ced1b2710565854b78abf782"
CROS_WORKON_TREE="88aeb70b515a41f329432d545d85f3b8a883666a"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest libchrome

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
	containers? (
		tests_security_Libcontainer? (
			chromeos-base/minijail
			chromeos-base/libcontainer
		)
	)
"
DEPEND="${RDEPEND}"

IUSE_TESTS="
	!chromeless_tty? (
		!chromeless_tests? (
			+tests_security_RendererSandbox
			+tests_security_SessionManagerDbusEndpoints
		)
	)
	seccomp? (
		+tests_security_SeccompSyscallFilters
	)
	containers? ( +tests_security_Libcontainer )
	+tests_security_NosymfollowMountOption
	+tests_security_ProcessManagementPolicy
	+tests_security_RootfsOwners
	+tests_security_SysVIPC
	x86? ( +tests_security_x86Registers )
	amd64? ( +tests_security_x86Registers )
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
