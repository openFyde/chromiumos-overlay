# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
CROS_WORKON_COMMIT="444ab0340a5fe547d46c0b8d9c5c3f6ac86eb80b"
CROS_WORKON_TREE="7005b078a693f7474dd2e9e3263b3b39ca2aba51"
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
	+tests_bluetooth_AdapterLLTHealth
	+tests_bluetooth_AdapterMDHealth
	+tests_bluetooth_AdapterMTBF
	+tests_bluetooth_AdapterPowerMeasure
	+tests_bluetooth_AdapterQuickHealth
	+tests_bluetooth_AdapterSAHealth
	+tests_bluetooth_AdapterSRHealth
	+tests_bluetooth_PeerUpdate
	+tests_bluetooth_PeerVerify
"

IUSE_TESTS="${IUSE_TESTS}
	${SERVER_IUSE_TESTS}
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
