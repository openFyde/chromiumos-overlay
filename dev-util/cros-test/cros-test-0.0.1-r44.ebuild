# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="88700216f0f64842c27a1fe37d41045d411ab7d1"
CROS_WORKON_TREE=("dff5dbbc378a882b1163db16db5650e7673a74c7" "45ab94459c8afbb76a27fe28f1267e71197c1ba1")
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
