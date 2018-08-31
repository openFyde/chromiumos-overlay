# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="8776cec2e9a3ec805f21e65d37ea6d708766df9f"
CROS_WORKON_TREE="6242bcda446754be4d2491ddbd8eee648fd23115"
CROS_WORKON_PROJECT="chromiumos/platform/tast"
CROS_WORKON_LOCALNAME="tast"

CROS_GO_BINARIES=(
	"chromiumos/cmd/local_test_runner"
)

CROS_GO_TEST=(
	"chromiumos/cmd/local_test_runner/..."
	# Also test common code.
	"chromiumos/tast/..."
)

inherit cros-go cros-workon

DESCRIPTION="Runner for local integration tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="dev-go/crypto"
RDEPEND="
	app-arch/tar
	!chromeos-base/tast-common
"
