# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="0a7c6c7a1cdb6e7894d823b8d2bf2381caf3e41b"
CROS_WORKON_TREE="3eecec9ab91ce61159a92baf6ba73a72f9d5b43e"
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
