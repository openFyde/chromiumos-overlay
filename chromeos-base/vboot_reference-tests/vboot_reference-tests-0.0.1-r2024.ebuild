# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="13f601fbd4c1b128f333391e4552082594f0ff25"
CROS_WORKON_TREE="4ae29d731f370835f790e8a571cc13d9c5e3025b"
CROS_WORKON_PROJECT="chromiumos/platform/vboot_reference"

inherit cros-workon autotest

DESCRIPTION="vboot tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"

# Enable autotest by default.
IUSE="${IUSE} +autotest"

IUSE_TESTS="
	+tests_firmware_VbootCrypto
"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_LOCALNAME=platform/vboot_reference

# path from root of repo
AUTOTEST_CLIENT_SITE_TESTS=autotest/client

src_compile() {
	# for Makefile
	export VBOOT_SRC_DIR=${WORKDIR}/${P}
	autotest_src_compile
}
