# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="chromiumos/platform/tast-tests"
CROS_WORKON_LOCALNAME="tast-tests"
CROS_WORKON_BLACKLIST=1

CROS_GO_BINARIES=(
	"chromiumos/cmd/remote_tests"
)

# Support packages live outside of cmd/.
CROS_GO_TEST=(
	"chromiumos/tast/remote/..."
)

inherit cros-go cros-workon

DESCRIPTION="Remote integration tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
IUSE=""

DEPEND="chromeos-base/tast-common"
RDEPEND=""
