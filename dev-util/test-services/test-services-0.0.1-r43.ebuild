# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b27457daf07aee13015600faf5b4bf786dbfec36"
CROS_WORKON_TREE="b059d77f5bdfe702bc0c939b23ad7912cd38216f"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="../platform/dev"
CROS_WORKON_SUBTREE="src"

inherit cros-workon

DESCRIPTION="Collection of test services installed into the cros_sdk env"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

# TODO(b/182898188): Re-add test-plan once proto changes have been integrated.
DEPEND="
	dev-util/provision-server
	dev-util/testlabenv-local
	dev-util/cros-test
	dev-util/dut-server
"
RDEPEND="
	${DEPEND}
	!<chromeos-base/test-server-0.0.1-r49
	"
