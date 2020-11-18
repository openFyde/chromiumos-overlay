# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="72ae59a2f2e76833fedc6ffd43094161cfb9cf26"
CROS_WORKON_TREE="60078bddd8e4d91db94a27ddb7669710b9a81632"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"

inherit cros-workon autotest

DESCRIPTION="Cellular autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
# Enable autotest by default.
IUSE="${IUSE} +autotest"

RDEPEND="
	!<chromeos-base/autotest-tests-0.0.2
	chromeos-base/autotest-deps-cellular
	chromeos-base/shill-test-scripts
	dev-python/pygobject
	dev-python/pyusb
	sys-apps/ethtool
"
DEPEND="${RDEPEND}"

IUSE_TESTS="
	+tests_cellular_ActivateLTE
	+tests_cellular_ConnectFailure
	+tests_cellular_DeferredRegistration
	+tests_cellular_DisableWhileConnecting
	+tests_cellular_DisconnectFailure
	+tests_cellular_Identifiers
	+tests_cellular_OutOfCreditsSubscriptionState
	+tests_cellular_SIMLocking
	+tests_cellular_SafetyDance
	+tests_cellular_ScanningProperty
	+tests_cellular_ServiceName
	+tests_cellular_Smoke
	+tests_cellular_StressEnable
"

IUSE_MBIM_TESTS="
	+tests_cellular_MbimComplianceControlCommand
	+tests_cellular_MbimComplianceControlRequest
	+tests_cellular_MbimComplianceDataTransfer
	+tests_cellular_MbimComplianceDescriptor
	+tests_cellular_MbimComplianceError
"

IUSE_TESTS="${IUSE_TESTS} ${IUSE_MBIM_TESTS}"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_LOCALNAME="third_party/autotest/files"

AUTOTEST_DEPS_LIST=""
AUTOTEST_CONFIG_LIST=""
AUTOTEST_PROFILERS_LIST=""

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
