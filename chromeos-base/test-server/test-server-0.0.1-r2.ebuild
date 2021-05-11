# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e4232e85c30cfb229af8bfb0bd0cad2b5f70971e"
CROS_WORKON_TREE=("48547f8b1976f6abfd87274a7eaa0da74cedab9e" "9ac72c9a4dbeb3077335ea0968ce4441034c2de5")
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
