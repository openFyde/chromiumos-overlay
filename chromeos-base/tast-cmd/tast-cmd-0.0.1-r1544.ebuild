# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2416b937f833c8551eaf029741ac43e87a5f2931"
CROS_WORKON_TREE="e5b3f65f8570bc9a609a8ea268b7f0bcb79cd15b"
CROS_WORKON_PROJECT="chromiumos/platform/tast"
CROS_WORKON_LOCALNAME="platform/tast"

CROS_GO_BINARIES=(
	"chromiumos/tast/cmd/remote_test_runner"
	"chromiumos/tast/cmd/tast"
)

CROS_GO_VERSION="${PF}"

CROS_GO_TEST=(
	"chromiumos/tast/cmd/remote_test_runner/..."
	"chromiumos/tast/cmd/tast/..."
	# Also test common code.
	"chromiumos/tast/..."
)
CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

inherit cros-go cros-workon

DESCRIPTION="Host executables for running integration tests"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

# Build-time dependencies should be added to tast-build-deps, not here.
DEPEND="chromeos-base/tast-build-deps:="

RDEPEND="
	app-arch/tar
	app-arch/xz-utils
	chromeos-base/google-breakpad
	chromeos-base/tast-build-deps
	chromeos-base/tast-vars
	net-misc/gsutil
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
