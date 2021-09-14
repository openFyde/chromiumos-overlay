# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d8f9833d542d0aa6a4732dbbb5176205c0ca1dae"
CROS_WORKON_TREE="d32cf7a33f2aaa07fe53ca69cb08b2e6aba86bdd"
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
