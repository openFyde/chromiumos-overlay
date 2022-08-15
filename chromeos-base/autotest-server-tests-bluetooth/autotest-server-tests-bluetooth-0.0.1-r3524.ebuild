# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="034c3f8862d774f69cc2ec42c21f94f2d1a21d21"
CROS_WORKON_TREE="1c522139adbd4c12d7617c5dc28700918975cbd8"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest

DESCRIPTION="Autotest server tests for Bluetooth"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

# Enable autotest by default.
IUSE="+autotest"

RDEPEND="
	!<chromeos-base/autotest-server-tests-0.0.2-r4126
"

SERVER_IUSE_TESTS="
	+tests_bluetooth_AdapterAdvHealth
	+tests_bluetooth_AdapterAdvMonitor
	+tests_bluetooth_AdapterAudioLink
	+tests_bluetooth_AdapterAUHealth
	+tests_bluetooth_AdapterCLHealth
	+tests_bluetooth_AdapterEPHealth
	+tests_bluetooth_AdapterLEAdvertising
	+tests_bluetooth_AdapterLEBetterTogether
	+tests_bluetooth_AdapterLEHIDHealth
	+tests_bluetooth_AdapterLEHealth
	+tests_bluetooth_AdapterLLPrivacyHealth
	+tests_bluetooth_AdapterLLTHealth
	+tests_bluetooth_AdapterMDHealth
	+tests_bluetooth_AdapterMTBF
	+tests_bluetooth_AdapterPowerMeasure
	+tests_bluetooth_AdapterQRHealth
	+tests_bluetooth_AdapterQuickHealth
	+tests_bluetooth_AdapterRvR
	+tests_bluetooth_AdapterSAHealth
	+tests_bluetooth_AdapterSRHealth
	+tests_bluetooth_FastPair
	+tests_bluetooth_PeerUpdate
	+tests_bluetooth_PeerVerify
"

IUSE_TESTS="${IUSE_TESTS}
	${SERVER_IUSE_TESTS}
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
