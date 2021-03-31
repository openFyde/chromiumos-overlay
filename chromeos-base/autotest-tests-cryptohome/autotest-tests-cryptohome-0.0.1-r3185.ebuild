# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="01ee2cff9a523dfc14a75f72b3e0795558523bef"
CROS_WORKON_TREE="cd7e6e6bf7267542779bedc657db2dd6e0b10052"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest

DESCRIPTION="Cryptohome autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
# Enable autotest by default.
IUSE="+autotest"

COMMON_DEPEND="
	!<chromeos-base/autotest-tests-0.0.3
"

RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/cryptohome-dev-utils
"

DEPEND="
	${COMMON_DEPEND}
"

IUSE_TESTS="
	+tests_platform_CryptohomeFio
	+tests_platform_CryptohomeLECredentialManager
	+tests_platform_CryptohomeLECredentialManagerServer
	+tests_platform_CryptohomeStress
	+tests_platform_CryptohomeTPMReOwn
	+tests_platform_CryptohomeTPMReOwnServer
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
