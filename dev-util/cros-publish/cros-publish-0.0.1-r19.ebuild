# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b6f0684956bfbf53bcf431dd78d76ede58d936bc"
CROS_WORKON_TREE="9cde03f2fbff048472fb2966b9016b364d6b93cd"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/publish"

inherit cros-go cros-workon

DESCRIPTION="Publish server implementation for uploading test result artifacts to GCS bucket"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/publish"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}"
)

CROS_GO_BINARIES=(
	"chromiumos/test/publish/cmd/gcs-publish"
	"chromiumos/test/publish/cmd/tko-publish"
	"chromiumos/test/publish/cmd/rdb-publish"
)

CROS_GO_TEST=(
	"chromiumos/test/publish/cmd/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	dev-go/crypto
	dev-go/gcp-storage
	dev-go/grpc
	dev-go/infra-proto
	dev-go/luci-go-common
	dev-go/mock
	dev-go/protobuf
	dev-go/protobuf-legacy-api
	dev-util/lro-server
	chromeos-base/cros-config-api
"
RDEPEND="${DEPEND}"

src_prepare() {
	# CGO_ENABLED=0 will make the executable statically linked.
	export CGO_ENABLED=0

	default
}
