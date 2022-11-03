# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="c7ee78b2c297e13ec6a151cd497e931243ef4c16"
CROS_WORKON_TREE="7a88723cd1d5f0741a1baa567bc7483e8f18e2d5"
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
