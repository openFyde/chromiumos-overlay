# Copyright 2010 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="1e8209144c3411acfe738f148f60518e361734ce"
CROS_WORKON_TREE="44c98cc7097b9db8181d639fcdc9671c90b5b932"
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
