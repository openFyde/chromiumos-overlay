# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7f50d12fe70af3bc0a77bcbf1a20ff3432ca9786"
CROS_WORKON_TREE="b13002943aea26f8480b6e10924061d6210198a6"
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
	dev-util/cros-provision
	dev-util/testlabenv-local
	dev-util/cros-test
	dev-util/cros-dut
	dev-util/cros-test-finder
	dev-util/test-plan
"
RDEPEND="
	${DEPEND}
	!<chromeos-base/test-server-0.0.1-r49
	"
