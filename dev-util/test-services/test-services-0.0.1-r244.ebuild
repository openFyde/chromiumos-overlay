# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="312c45c32e8d535da3264a9843650ef5df58512d"
CROS_WORKON_TREE="61d98b03f4ee3b1f0bafff47bc1d16f734445f2b"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="../platform/dev"
CROS_WORKON_SUBTREE="src"

inherit cros-workon

DESCRIPTION="Collection of test services installed into the cros_sdk env"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-util/cros-dut
	dev-util/cros-provision
	dev-util/cros-publish
	dev-util/cros-servod
	dev-util/cros-test
	dev-util/cros-test-finder
	!dev-util/fw-provision
	dev-util/cros-fw-provision
	dev-util/testlabenv-local
	dev-util/test-plan
"
RDEPEND="
	${DEPEND}
	!<chromeos-base/test-server-0.0.1-r49
	"
