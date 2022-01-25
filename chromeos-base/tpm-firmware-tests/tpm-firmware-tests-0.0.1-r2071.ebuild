# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="78bb610cc96862d5fb55acf8ef4c6c3e99843649"
CROS_WORKON_TREE="1680f1aa8b4103cd0e67a832a7fb88c6ad089d24"
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


