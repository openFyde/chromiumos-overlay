# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9b1c421f3ddff94b937f745f5e7deabd5fbb2f02"
CROS_WORKON_TREE="e1388719e5668cb791bdd5f115f0d9fde949511e"
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
"
RDEPEND="${DEPEND}"
