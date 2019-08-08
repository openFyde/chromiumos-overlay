# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="f7e01f1fca8a4a6d5e3dfe37e670db3e3c15b2b6"
CROS_WORKON_TREE="e32f2b4125be32bb88965809d90f1fce8ba44df1"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest/files

inherit cros-workon autotest

DESCRIPTION="Cryptohome autotests"
HOMEPAGE="http://www.chromium.org/"
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
	+tests_platform_BootLockbox
	+tests_platform_CryptohomeBadPerms
	+tests_platform_CryptohomeChangePassword
	+tests_platform_CryptohomeFio
	+tests_platform_CryptohomeGetEnrollmentId
	+tests_platform_CryptohomeKeyEviction
	+tests_platform_CryptohomeLECredentialManager
	+tests_platform_CryptohomeLECredentialManagerServer
	+tests_platform_CryptohomeMigrateChapsToken
	+tests_platform_CryptohomeMigrateChapsTokenClient
	+tests_platform_CryptohomeMigrateKey
	+tests_platform_CryptohomeMount
	+tests_platform_CryptohomeMultiple
	+tests_platform_CryptohomeNonDirs
	+tests_platform_CryptohomeStress
	+tests_platform_CryptohomeTestAuth
	+tests_platform_CryptohomeTpmLiveTest
	+tests_platform_CryptohomeTpmLiveTestServer
	+tests_platform_CryptohomeTPMReOwn
	+tests_platform_CryptohomeTPMReOwnServer
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
