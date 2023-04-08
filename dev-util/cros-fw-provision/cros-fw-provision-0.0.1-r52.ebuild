# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e0f54038d2b2406fd2aa6f7070e9c8ad763c916a"
CROS_WORKON_TREE="f77b59fef9ab500e96316d604fe374d0e6e15f0d"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/provision"

inherit cros-go cros-workon

DESCRIPTION="Firmware provisioning implementation for CFT"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/provision/v2/cros-fw-provision"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}"
)

CROS_GO_BINARIES=(
	"chromiumos/test/provision/v2/cros-fw-provision"
)

CROS_GO_TEST=(
	"chromiumos/test/provision/v2/cros-fw-provision"
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	!dev-util/fw-provision
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
