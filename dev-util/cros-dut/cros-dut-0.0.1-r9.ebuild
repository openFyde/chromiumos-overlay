# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f4a9fc4d054b66891f37995b6bf056d21e97fe45"
CROS_WORKON_TREE="507302c05edbb94d243767cff325e229952a24ab"
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
	"chromiumos/test/dut/cmd/cros-dut"
)

CROS_GO_TEST=(
	"chromiumos/test/dut/cmd/cros-dut/..."
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

src_prepare() {
	# Disable cgo and PIE on building binaries. See:
	# https://crbug.com/976196
	# https://github.com/golang/go/issues/30986#issuecomment-475626018
	export CGO_ENABLED=0
	export GOPIE=0

	default
}
