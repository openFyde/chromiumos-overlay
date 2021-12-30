# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="d0f654c231c2a3f10f25bf1597ca8d593260b297"
CROS_WORKON_TREE="a39cb4e1ff0724176270c00dc5e5fc11337f390c"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest

DESCRIPTION="debugd autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
# Enable autotest by default.
IUSE="+autotest"

RDEPEND="
	!<chromeos-base/autotest-tests-0.0.3
"

IUSE_TESTS="
	+tests_platform_TraceClockMonotonic
	+tests_platform_DebugDaemonGetNetworkStatus
	+tests_platform_DebugDaemonGetPerfData
	+tests_platform_DebugDaemonGetPerfOutputFd
	+tests_platform_DebugDaemonGetRoutes
	+tests_platform_DebugDaemonPerfDataInFeedbackLogs
	+tests_platform_DebugDaemonPing
	+tests_platform_DebugDaemonTracePath
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
