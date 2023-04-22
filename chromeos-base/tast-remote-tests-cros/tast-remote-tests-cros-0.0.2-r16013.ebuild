# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("d5c618e6efbc9d461a135f7a783875be71beb11a" "7e7781c133f6ad1df601837bec338891de358581" "81841768f4ed37966233c24b762a906d0360e748")
CROS_WORKON_TREE=("edaeaa2a28e5ca9e3e03b8b061b7a5e33730dd67" "c6c1c427454f45afa33b6b68dd933fc9ba0c417f" "d0d3840c5257cf0aeaf8adaa9792cd9224b8cc1e")
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
	"go.chromium.org/tast/..."
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
