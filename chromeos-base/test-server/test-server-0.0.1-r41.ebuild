# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e46d491f7c8b37469f0eaf0dd231a60dd8aadf33"
CROS_WORKON_TREE="97f1a5103358a614eebde965fa7fd7de15b7ca61"
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

#TODO(jaquesc): Re-add dev-util/dut-server once the server has all functionality
DEPEND="
	dev-util/provision-server
	dev-util/test-exec-server
	dev-util/test-plan
"
RDEPEND="${DEPEND}"
