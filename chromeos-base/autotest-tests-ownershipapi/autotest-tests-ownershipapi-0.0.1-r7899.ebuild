# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="6d56a91e36c7415ef754171fe84cab5df045334c"
CROS_WORKON_TREE="0afe9e545add6bbfe1e753734251c983a93fad69"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"

inherit cros-workon autotest python-any-r1

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
