# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest

DESCRIPTION="Audio autotests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~*"
# Enable autotest by default.
IUSE="+autotest -chromeless_tty"

RDEPEND="
	!<chromeos-base/autotest-tests-0.0.3
	chromeos-base/audiotest
	!chromeless_tty? ( chromeos-base/telemetry )
"
DEPEND="${RDEPEND}"

# audio_AudioInputGain and audio_CrasGetNodes depend on telemetry.
IUSE_TESTS="
	+tests_audio_Aconnect
	+tests_audio_AlsaLoopback
	+tests_audio_Aplay
	!chromeless_tty? (
		+tests_audio_AudioInputGain
		+tests_audio_CrasGetNodes
	)
	+tests_audio_CRASFormatConversion
	+tests_audio_CrasDevSwitchStress
	+tests_audio_CrasLoopback
	+tests_audio_CrasPinnedStream
	+tests_audio_CrasStress
	+tests_audio_LoopbackLatency
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"

src_prepare() {
	if ! use chromeless_tty; then
		# Telemetry tests require the path to telemetry source to exist in order to
		# build. Copy the telemetry source to a temporary directory that is writable,
		# so that file removals in Telemetry source can be performed properly.
		export TMP_DIR="$(mktemp -d)"
		cp -r "${SYSROOT}/usr/local/telemetry" "${TMP_DIR}"
		export PYTHONPATH="${TMP_DIR}/telemetry/src/third_party/catapult/telemetry"
	fi
	autotest_src_prepare
}
