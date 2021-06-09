# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2691399ee39288d890b333798ea5305adc15c2e8"
CROS_WORKON_TREE="d2c57f38a734db22ee0953627fc6a2fde2130b5c"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_SUBTREE="src"

inherit cros-workon

# TODO(shapiroc): Rename package to test-services
DESCRIPTION="Collection of test services installed into the cros_sdk env"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-util/provision-server
	dev-util/test-exec-server
	dev-util/dut-server
"
RDEPEND="${DEPEND}"
