# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f21d25cccd6b52cba50505dd5c4f34b7b3224e44"
CROS_WORKON_TREE="79d9901dd26d4d5c0d154dd52379e13a0caa7803"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_SUBTREE="src"

inherit cros-workon

# TODO(shapiroc): Rename package to test-services
DESCRIPTION="Collection of test services installed into the cros_sdk env"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

#TODO(jaquesc): Re-add dev-util/dut-server once the server has all functionality
DEPEND="
	dev-util/provision-server
	dev-util/test-exec-server
	dev-util/test-plan
"
RDEPEND="${DEPEND}"
