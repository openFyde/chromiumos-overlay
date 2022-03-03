# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python{3_6,3_7,3_8} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"

inherit cros-workon autotest python-any-r1

DESCRIPTION="Cellular autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
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
	+tests_cellular_ConnectFailure
	+tests_cellular_DisableWhileConnecting
	+tests_cellular_DisconnectFailure
	+tests_cellular_HermesErrorScenarios
	+tests_cellular_HermesMM_InstallEnable
	+tests_cellular_Hermes_MultiProfile
	+tests_cellular_Hermes_Restart_SlotSwitch
	+tests_cellular_Hermes_SingleProfile
	+tests_cellular_Identifiers
	+tests_cellular_SIMLocking
	+tests_cellular_SafetyDance
	+tests_cellular_Smoke
	+tests_cellular_StressEnable
	+tests_cellular_ValidateTestEnvironment
"

IUSE_MBIM_TESTS="
"

IUSE_TESTS="${IUSE_TESTS} ${IUSE_MBIM_TESTS}"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_LOCALNAME="third_party/autotest/files"

AUTOTEST_DEPS_LIST=""
AUTOTEST_CONFIG_LIST=""
AUTOTEST_PROFILERS_LIST=""

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
