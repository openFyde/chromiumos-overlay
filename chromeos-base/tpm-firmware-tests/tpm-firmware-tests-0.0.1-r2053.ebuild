# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="8028cac33c9c408f90de9ceffc714a1a0ca9d583"
CROS_WORKON_TREE="3481b5003e43a04ebdd01f92ea29e9088ed18a20"
CROS_WORKON_PROJECT="chromiumos/platform/vboot_reference"

inherit cros-workon autotest

DESCRIPTION="TPM firmware tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/"
SRC_URI=""
LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
DEPEND="
	app-crypt/trousers:=
	chromeos-base/tpm:=
"

# Enable autotest by default.
IUSE="${IUSE} +autotest"

IUSE_TESTS="
	+tests_hardware_TPMFirmware
	+tests_hardware_TPMFirmwareServer
"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_LOCALNAME=vboot_reference

# path from root of repo
AUTOTEST_CLIENT_SITE_TESTS=autotest/client
AUTOTEST_SERVER_SITE_TESTS=autotest/server

function src_compile {
	# for Makefile
	export VBOOT_DIR=${WORKDIR}/${P}
	export MINIMAL=1  # Makefile requires this for cross-compiling
	autotest_src_compile
}


