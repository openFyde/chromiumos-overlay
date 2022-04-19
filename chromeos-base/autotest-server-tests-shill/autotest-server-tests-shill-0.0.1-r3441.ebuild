# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
CROS_WORKON_COMMIT="7ef64e519ff5c29f12e93d4d4788370272e8e022"
CROS_WORKON_TREE="7d796f983130ad38f480d87682077330f89b89ef"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest

DESCRIPTION="Autotest server tests for shill"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Enable autotest by default.
IUSE="-chromeless_tests +autotest -chromeless_tty"

SERVER_IUSE_TESTS="
	+tests_network_WiFi_AssocConfigPerformance
	+tests_network_WiFi_AttenuatedPerf
	+tests_network_WiFi_BluetoothScanPerf
	+tests_network_WiFi_BluetoothStreamPerf
	+tests_network_WiFi_ChaosConfigFailure
	+tests_network_WiFi_ChaosConnectDisconnect
	+tests_network_WiFi_ChaosLongConnect
	!chromeless_tty (
		!chromeless_tests (
			+tests_cellular_ChromeEndToEnd
			+tests_network_WiFi_ChromeEndToEnd
		)
	)
	+tests_network_WiFi_Perf
	+tests_network_WiFi_StressTest
	+tests_network_WiFi_Throttle
	+tests_network_WiFi_UpdateRouter
	+tests_network_WiFi_VerifyRouter
"

IUSE_TESTS="${IUSE_TESTS}
	${SERVER_IUSE_TESTS}
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
