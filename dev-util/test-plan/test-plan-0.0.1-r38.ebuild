# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="564ba6a77acac4e54b8c7394520c4a894b858e26"
CROS_WORKON_TREE="dac14e7d9f05dc347eba067d9cb836b950c51651"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/plan"

inherit cros-go cros-workon

DESCRIPTION="A tool to generate ChromeOS CoverageRule protos from SourceTestPlan protos."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/plan"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_BINARIES=(
	"chromiumos/test/plan/cmd/testplan.go"
)

CROS_GO_TEST=(
	"chromiumos/test/plan/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

CROS_GO_VERSION="${PF}"

DEPEND="
	chromeos-base/cros-config-api
	dev-go/glog
	dev-go/infra-proto
	dev-go/luci-go-common
	dev-go/maruel-subcommands
	dev-go/protobuf
	dev-go/protobuf-legacy-api
"
RDEPEND="${DEPEND}"

src_prepare() {
	# Disable CGO to produce a static executable that can
	# be copied into Docker containers.
	export CGO_ENABLED=0

	default
}
