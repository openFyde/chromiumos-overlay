# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("38b4d6f6e6ad515b4778b3533c839ece9ccd9bf5" "0c1d10c77eb3d3d6dd30651f98b12ae4bd26f25b" "62028ef299ce679a6a239dcf2e2c2d0b081709a8")
CROS_WORKON_TREE=("5c32620641b84dcd04614453842a9da3a334ad1a" "169446ced71cd0b2a1f7e221efaa1073d8c07cf5" "18549533a6a548df46f07fc2735678208d4a66cd")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/tast-tests"
	"chromiumos/platform/tast"
	"chromiumos/platform/fw-testing-configs"
)
CROS_WORKON_LOCALNAME=(
	"platform/tast-tests"
	"platform/tast"
	"platform/tast-tests/src/chromiumos/tast/remote/firmware/data/fw-testing-configs"
)
CROS_WORKON_DESTDIR=(
	"${S}"
	"${S}/tast-base"
	"${S}/src/chromiumos/tast/remote/firmware/data/fw-testing-configs"
)

CROS_GO_WORKSPACE=(
	"${CROS_WORKON_DESTDIR[@]}"
)

CROS_GO_TEST=(
	# Also test support packages that live above remote/bundles/.
	"chromiumos/tast/..."
)
CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

TAST_BUNDLE_EXCLUDE_DATA_FILES="1"

inherit cros-workon tast-bundle

DESCRIPTION="Bundle of remote integration tests for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

# Build-time dependencies should be added to tast-build-deps, not here.
DEPEND="
	chromeos-base/tast-build-deps:=
	chromeos-base/cros-config-api
"

RDEPEND="
	chromeos-base/tast-tests-remote-data
	dev-python/pillow
	media-libs/opencv
"
