# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="912d1b4ff065b092a7e872978480cc15dfa622d4"
CROS_WORKON_TREE="3f944e064fae29a2078ec0ee45dd6f5d70fb4bbc"
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
	dev-util/provision-server
	dev-util/testlabenv-local
	dev-util/test-exec-server
	dev-util/test-plan
	dev-util/dut-server
"
RDEPEND="
	${DEPEND}
	!<chromeos-base/test-server-0.0.1-r49
	"
