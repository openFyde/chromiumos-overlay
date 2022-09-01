# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e8bf8ac89df4af5785aa367746d84f2ea957f12b"
CROS_WORKON_TREE="14d9d3ec1cdf7be83a0d2c01dee8ce9df3ac3ab4"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/lab/local"

inherit cros-go cros-workon

DESCRIPTION="Local test lab environment support (local DUT setup/wiring support for test execution)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/lab/local"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}"
)

CROS_GO_BINARIES=(
	"chromiumos/test/lab/local/cmd/inventoryserver"
)

CROS_GO_TEST=(
	"chromiumos/test/lab/local/cmd/inventoryserver/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	dev-go/genproto
	dev-go/mock
	dev-go/protobuf
	dev-go/protobuf-legacy-api
	chromeos-base/cros-config-api
"
RDEPEND="${DEPEND}"
