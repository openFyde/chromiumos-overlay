# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="427938654d3d9f0a41488b7db519f962407a3126"
CROS_WORKON_TREE=("7ba00cdbeceb51fbb98b5810fcae9b8cf17ed150" "09855d2410e6e37a86fc7e42e149c9f5ac3dc7ea")
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/execution src/chromiumos/test/util"

inherit cros-go cros-workon

DESCRIPTION="Test execution server for running tests and capturing results"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/execution"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_VERSION="${PF}"

CROS_GO_BINARIES=(
	"chromiumos/test/execution/cmd/cros-test"
)

CROS_GO_PACKAGES=(
	"chromiumos/test/execution/errors/..."
	"chromiumos/test/util/..."
)

CROS_GO_TEST=(
	"chromiumos/test/execution/cmd/cros-test/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	chromeos-base/tast-cmd:=
	chromeos-base/tast-proto
	dev-go/cmp
	dev-go/grpc
	dev-go/protobuf-legacy-api
	dev-util/lro-server
"
RDEPEND="${DEPEND}"

src_prepare() {
	# Disable cgo and PIE on building Tast binaries. See:
	# https://crbug.com/976196
	# https://github.com/golang/go/issues/30986#issuecomment-475626018
	export CGO_ENABLED=0
	export GOPIE=0

	default
}
