# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="1cd6205f48b260ca2e7ff1d62b74274b9d5d26ee"
CROS_WORKON_TREE="19516452dfe251c22c36ce3df46f80bb2c0b25ad"
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

# Build-time dependencies should be added to tast-build-deps, not here.
DEPEND="chromeos-base/tast-build-deps"

RDEPEND="
	app-arch/tar
	!chromeos-base/tast-common
"

src_prepare() {
	# Disable cgo and PIE on building Tast binaries. See:
	# https://crbug.com/976196
	# https://github.com/golang/go/issues/30986#issuecomment-475626018
	export CGO_ENABLED=0
	export GOPIE=0

	cros-workon_src_prepare
	default
}
