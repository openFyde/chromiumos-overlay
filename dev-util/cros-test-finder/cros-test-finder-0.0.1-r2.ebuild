# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="a93ae858a2a100468b83c431ef0a876c2a7db596"
CROS_WORKON_TREE=("8448d06d6fdd46bd5fd6bb708917780b5beba25c" "a5b7a8cfa5fee66dae2198d608c1767f315ab13d" "c9afc399522791888e0665a5d73e29da983c5335")
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME=("../platform/dev")
CROS_WORKON_SUBTREE="src/chromiumos/test/test_finder src/chromiumos/test/util src/chromiumos/test/execution"

inherit cros-go cros-workon

DESCRIPTION="Test finder for find tests that match the specified test suite tags"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/dev-util/+/HEAD/src/chromiumos/test/test_finder"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

CROS_GO_VERSION="${PF}"

CROS_GO_BINARIES=(
	"chromiumos/test/test_finder/cmd/cros-test-finder"
)

CROS_GO_TEST=(
	"chromiumos/test/test_finder/cmd/cros-test-finder/..."
)

CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

DEPEND="
	chromeos-base/tast-cmd:=
	chromeos-base/tast-proto
	dev-util/lro-server
"
RDEPEND="${DEPEND}"

src_prepare() {
	# Disable cgo and PIE on building Tast binaries. See:
	# https://crbug.com/976196
	# https://github.com/golang/go/issues/30986#issuecomment-475626018
	export CGO_ENABLED=0
	export GOPIE=0

	default
}
