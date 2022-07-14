# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="32272a0ae6be35fa97318b392b1a47e580f72cbc"
CROS_WORKON_TREE="e07d2460718c9f9257d9522da581735bd590db83"
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
	dev-util/cros-publish
	dev-util/cros-test-finder
	dev-util/test-plan
"
RDEPEND="
	${DEPEND}
	!<chromeos-base/test-server-0.0.1-r49
	"
