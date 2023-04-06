# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="02043b8e7f5c6d9cff650c88aa55765666b5a7e8"
CROS_WORKON_TREE="aa57dc8252f0c3a2ae5728109de9ad90ca83c9b5"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test"

inherit cros-go cros-workon

DESCRIPTION="cros-servod service for CFT"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/servod/cmd"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}"
)

CROS_GO_BINARIES=(
	"chromiumos/test/servod/cmd/cros-servod"
)

CROS_GO_TEST=(
	"chromiumos/test/servod/cmd/servodserver"
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	dev-util/lro-server
	dev-util/lroold-server
	dev-go/genproto
	dev-go/luci-go-common
	dev-go/mock
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
