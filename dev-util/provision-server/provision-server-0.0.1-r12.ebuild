# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="d9b2e0b95a66632da92a83aee63786d2779ef0e0"
CROS_WORKON_TREE="9378333820281ac5087b57b7b910556533f1e85e"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/provision"

inherit cros-go cros-workon

DESCRIPTION="Provision server implementation for installing CrOS on a test device"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/provision"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}"
)

CROS_GO_BINARIES=(
	"chromiumos/test/provision/cmd/provisionserver"
)

CROS_GO_TEST=(
	"chromiumos/test/provision/cmd/provisionserver/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	dev-util/lro-server
	dev-go/genproto-rpc
	dev-go/mock
	dev-go/protobuf
	chromeos-base/cros-config-api
"
RDEPEND="${DEPEND}"
