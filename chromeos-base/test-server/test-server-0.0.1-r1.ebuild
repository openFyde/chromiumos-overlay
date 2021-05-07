# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="609abf325fe7bfa482cf2b99f26f18295e38c208"
CROS_WORKON_TREE=("48547f8b1976f6abfd87274a7eaa0da74cedab9e" "bdeed081d475129fb0faf12bcdd9820273841e36")
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
)

CROS_GO_PACKAGES=(
	"chromiumos/lro/..."
)

CROS_GO_TEST=(
	"${CROS_GO_PACKAGES[@]}"
)

DEPEND="chromeos-base/tast-cmd:="

RDEPEND=""
