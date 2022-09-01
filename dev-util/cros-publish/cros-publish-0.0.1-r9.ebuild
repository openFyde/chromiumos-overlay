# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e8bf8ac89df4af5785aa367746d84f2ea957f12b"
CROS_WORKON_TREE="2713829e79edbac332177c00bf3ba7f29877920a"
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
	"chromiumos/test/publish/cmd/cros-publish"
)

CROS_GO_TEST=(
	"chromiumos/test/publish/cmd/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	dev-util/lro-server
	dev-go/crypto
	dev-go/gcp-storage
	dev-go/grpc
	dev-go/mock
	dev-go/protobuf
	dev-go/protobuf-legacy-api
	chromeos-base/cros-config-api
"
RDEPEND="${DEPEND}"
