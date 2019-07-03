# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="991a2928f602436f42a89cc56939da20e8a4a06f"
CROS_WORKON_TREE="f96668df9e9be20ba3eac26077fcd79087adfb35"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest/files

inherit cros-workon autotest

DESCRIPTION="Autotests involving the tpm"
HOMEPAGE="http://www.chromium.org/"
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
	+tests_platform_Attestation
	+tests_platform_Pkcs11InitUnderErrors
	+tests_platform_Pkcs11ChangeAuthData
	+tests_platform_Pkcs11Events
	+tests_platform_Pkcs11LoadPerf
	+tests_platform_TPMEvict
"

IUSE="${IUSE} ${IUSE_TESTS}"

AUTOTEST_FILE_MASK="*.a *.tar.bz2 *.tbz2 *.tgz *.tar.gz"
