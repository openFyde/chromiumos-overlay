# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="6a69124e0e3a3440d23293195256aa6abdd3b0b6"
CROS_WORKON_TREE="0784f2536cc879930eb9c9e8d27178348ffbb61e"
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
	chromeos-base/cros-config-api
"
RDEPEND="${DEPEND}"
