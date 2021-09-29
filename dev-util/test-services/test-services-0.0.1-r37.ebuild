# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7e198c4f0dc3185b1b1fac1129ef128fda0bb52f"
CROS_WORKON_TREE="0fa15d894d5985dd4434479024c4f104cc183be2"
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
	dev-util/test-exec-server
	dev-util/dut-server
"
RDEPEND="
	${DEPEND}
	!<chromeos-base/test-server-0.0.1-r49
	"
