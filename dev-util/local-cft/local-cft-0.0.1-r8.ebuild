# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9decf050014cded6d90c6cc45a1592a9e1df066a"
CROS_WORKON_TREE="4645fcaf6e03a2b1db94f019a76b5e8fe69db63d"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/local-cft"

inherit cros-go cros-workon

DESCRIPTION="Local implementation of test-runner for CFT"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/local-cft"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}"
)

CROS_GO_BINARIES=(
	"chromiumos/test/local-cft"
)

CROS_GO_TEST=(
	"chromiumos/test/local-cft/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	dev-util/lro-server
	dev-util/lroold-server
	dev-go/genproto
	dev-go/protobuf
	dev-go/protobuf-legacy-api
	chromeos-base/cros-config-api
"
RDEPEND="${DEPEND}"

src_prepare() {
	# CGO_ENABLED=0 will make the executable statically linked.
	export CGO_ENABLED=0

	default
}
