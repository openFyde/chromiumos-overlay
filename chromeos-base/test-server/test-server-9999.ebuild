# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_SUBTREE="test"

inherit cros-workon

# TODO(shapiroc): Rename package to test-services
DESCRIPTION="Collection of test services installed into the cros_sdk env"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/test"

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}/test"
)

CROS_GO_BINARIES=(
	"chromiumos/execution/cmd/executionserver"
)

CROS_GO_TEST=(
	"chromiumos/execution/cmd/executionserver/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	chromeos-base/tast-cmd:=
	dev-util/lro-server
"
RDEPEND="${DEPEND}"
