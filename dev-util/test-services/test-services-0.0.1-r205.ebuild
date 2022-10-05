# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5f28afda187b74e7f091312eaa94b994f1bc6b2b"
CROS_WORKON_TREE="4641dc23f39f7c7178bcb88ed6ee7b2bf8dede1d"
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
