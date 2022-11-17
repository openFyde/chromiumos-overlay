# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e5ac4de9fa6554d5d0a0379b743dd689a7c07d68"
CROS_WORKON_TREE="800400991a43dcc2896b63db1eaf8b33885b2260"
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
	dev-util/fw-provision
	dev-util/testlabenv-local
	dev-util/test-plan
"
RDEPEND="
	${DEPEND}
	!<chromeos-base/test-server-0.0.1-r49
	"
