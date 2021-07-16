# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3fc36525ee9bda1ae9e8f346162aa057f55e5637"
CROS_WORKON_TREE="14c357c72f029218e58ae242e687a5bbd0c5d9ed"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/dut"

inherit cros-go cros-workon

DESCRIPTION="DUT Service Server implementation for interfacing with the DUT"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/dut"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}"
)

CROS_GO_BINARIES=(
	"chromiumos/test/dut/cmd/dutserver"
)

CROS_GO_TEST=(
	"chromiumos/test/dut/cmd/dutserver/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	dev-util/lro-server
	dev-go/crypto
	dev-go/grpc
	dev-go/mock
	dev-go/protobuf
	chromeos-base/cros-config-api
"
RDEPEND="${DEPEND}"
