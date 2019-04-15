# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="e4ea299b148c89d6212b7b4954b94b851d581483"
CROS_WORKON_TREE="4f6fc891b0b6e1968d36904b3f8f56c46dacd120"
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
CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

inherit cros-go cros-workon

DESCRIPTION="Runner for local integration tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-go/crypto
	dev-go/yaml
"
RDEPEND="
	app-arch/tar
	!chromeos-base/tast-common
"
