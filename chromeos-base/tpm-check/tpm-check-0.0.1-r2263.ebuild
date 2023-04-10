# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="5291abb22297ff0fd3a5f5ec4e4c22c1b0455017"
CROS_WORKON_TREE="bb930c7d4d75c1bbe2b1b512504104be6dfb4d4e"
CROS_WORKON_PROJECT="chromiumos/platform/vboot_reference"

inherit cros-workon autotest

DESCRIPTION="tpm check test"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/vboot_reference/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"

# Enable autotest by default.
IUSE="${IUSE} +autotest"

IUSE_TESTS="
	+tests_hardware_TPMCheck
"

IUSE="${IUSE} ${IUSE_TESTS}"

CROS_WORKON_LOCALNAME=platform/vboot_reference

# path from root of repo
AUTOTEST_CLIENT_SITE_TESTS=autotest/client
