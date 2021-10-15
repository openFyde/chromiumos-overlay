# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="68c72fbac292b1d2f7955a2fa4c497a886219c03"
CROS_WORKON_TREE="bf335b529bf3339534427fb252b0fb7764a53e56"
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
	dev-util/cros-provision
	dev-util/testlabenv-local
	dev-util/cros-test
	dev-util/dut-server
"
RDEPEND="
	${DEPEND}
	!<chromeos-base/test-server-0.0.1-r49
	"
