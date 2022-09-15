# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="8333412a9b5f88561f298edb61e586b2ea248ca6"
CROS_WORKON_TREE="3b6497abd42cffa9fb1fab2f76925fae42839b39"
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon autotest python-any-r1

DESCRIPTION="Autotests involving the tpm"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
# Enable autotest by default.
IUSE="+autotest tpm2"

RDEPEND="
	!<chromeos-base/autotest-tests-0.0.3
	tpm2? ( chromeos-base/g2f_tools )
"
DEPEND="${RDEPEND}"

IUSE_TESTS="
	+tests_firmware_Cr50VirtualNVRam
	+tests_firmware_Cr50VirtualNVRamServer
	+tests_firmware_Cr50U2fPowerwash
	+tests_hardware_TPMCheck
	+tests_kernel_TPMStress
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
