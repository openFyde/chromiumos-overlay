# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="78cd21aa54359da7727c5dc5d264fbc9115e85a0"
CROS_WORKON_TREE="6b485afe1c6b4ff36195f0cfdc3350eef993d950"
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
	+tests_platform_CryptohomeStress
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
