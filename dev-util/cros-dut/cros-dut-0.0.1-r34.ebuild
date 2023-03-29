# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0713cd4f84ea5b4791d10ea62842e1ce9a95f5d9"
CROS_WORKON_TREE=("4aa3bb6090ebfd6cdfd267679ce3d142b90a18c6" "bfb101699df26ca500a50c7b7e6f73c2dfd8b56e")
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/dut src/chromiumos/test/util"

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
	dev-go/protobuf-legacy-api
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
