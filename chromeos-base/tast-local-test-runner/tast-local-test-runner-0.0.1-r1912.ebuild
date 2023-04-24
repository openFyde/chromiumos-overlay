# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0f30d4bad2cc66353ed7447e782089f7239f6e10"
CROS_WORKON_TREE="1b81a58554d2ff4c5bbe927248456456468f42d5"
CROS_WORKON_PROJECT="chromiumos/platform/tast"
CROS_WORKON_LOCALNAME="platform/tast"

CROS_GO_BINARIES=(
	"go.chromium.org/tast/core/cmd/local_test_runner"
)

CROS_GO_TEST=(
	"go.chromium.org/tast/core/cmd/local_test_runner/..."
)
CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

inherit cros-go cros-workon

DESCRIPTION="Runner for local integration tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

# Build-time dependencies should be added to tast-build-deps, not here.
DEPEND="chromeos-base/tast-build-deps:="

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

	default
}
