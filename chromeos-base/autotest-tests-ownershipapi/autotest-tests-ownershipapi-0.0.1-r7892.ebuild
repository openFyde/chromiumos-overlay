# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="99e5f02e736eab3dd1445834c1f26f46db85e452"
CROS_WORKON_TREE="54ff09d88d01f0b74b519616c18d7e964daafc53"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"

inherit cros-workon autotest

DESCRIPTION="login_OwnershipApi autotest"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="+xset +tpmtools"
# Enable autotest by default.
IUSE="${IUSE} +autotest"

RDEPEND="${RDEPEND}
	chromeos-base/autotest-deps-dbus
	chromeos-base/autotest-deps-policy
	chromeos-base/chromeos-chrome
	chromeos-base/telemetry
	dev-python/protobuf-python
	dev-python/pygobject
"

DEPEND="${RDEPEND}"

# The telemetry dependency comes from the chrome.py import in some of the tests.
IUSE_TESTS="
	+tests_login_CryptohomeOwnerQuery
	+tests_login_MultipleSessions
"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_LOCALNAME="third_party/autotest/files"

AUTOTEST_DEPS_LIST=""
AUTOTEST_CONFIG_LIST=""
AUTOTEST_PROFILERS_LIST=""

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"

src_prepare() {
	# Telemetry tests require the path to telemetry source to exist in order to
	# build.  Copy the telemetry source to a temporary directory that is writable,
	# so that file removals in Telemetry source can be performed properly.
	export TMP_DIR="$(mktemp -d)"
	cp -r "${SYSROOT}/usr/local/telemetry" "${TMP_DIR}"
	export PYTHONPATH="${TMP_DIR}/telemetry/src/third_party/catapult/telemetry"
	autotest_src_prepare
}
