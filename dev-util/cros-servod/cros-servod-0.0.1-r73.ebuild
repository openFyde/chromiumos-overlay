# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="078d022fb8ecaafb990232c8702839a72e21ac0a"
CROS_WORKON_TREE="2afc1e11f224e251b5c17220fd54c9f7bd706719"
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
	sys-firmware/ap-firmware-config
"
RDEPEND="${DEPEND}"

src_prepare() {
	# CGO_ENABLED=0 will make the executable statically linked.
	export CGO_ENABLED=0

	default
}
