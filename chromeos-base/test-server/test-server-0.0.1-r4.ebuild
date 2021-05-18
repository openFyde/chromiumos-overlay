# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="15370e0be594895ae50a78fda89489c0a46f0be3"
CROS_WORKON_TREE=("48547f8b1976f6abfd87274a7eaa0da74cedab9e" "79b6c69ffbc4a36a4e7c898b1f8399c76f1af26c")
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="platform/dev"
CROS_WORKON_SUBTREE="lib test"

inherit cros-go cros-workon

DESCRIPTION="Test server for device provisioning, test execution, and results capture"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/test"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_WORKSPACE=(
	"${S}/lib"
	"${S}/test"
)

CROS_GO_PACKAGES=(
	"chromiumos/lro/..."
)

CROS_GO_BINARIES=(
	"chromiumos/testservice/cmd/testservice"
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
	"chromiumos/testservice/cmd/testservice/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="chromeos-base/tast-cmd:="

RDEPEND=""
