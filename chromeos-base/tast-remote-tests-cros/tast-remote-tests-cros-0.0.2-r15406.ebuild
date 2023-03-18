# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("83a5c84f04cd3bc71ca3db7c0b57fd15d055f8c1" "9bf548ca56aa937d2f6a68de72414a4e9564086d" "a2bba92548e18fd69db48523cc016d89dc3afec6")
CROS_WORKON_TREE=("b1668268574c35ab54433a94b43903a50520d3c1" "f726743a39fdfd8e86ca345862b79624d2c3b217" "32ec1a82541af4b581518954b2a95981559af8a9")
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
