# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b352faae79b45e24c178fa6ab03134662df84b41"
CROS_WORKON_TREE="8a34a2b9c816db9885f9bcc8ef7e88eb42855232"
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
