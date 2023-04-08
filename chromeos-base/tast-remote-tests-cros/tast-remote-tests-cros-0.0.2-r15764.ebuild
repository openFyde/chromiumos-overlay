# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("19616f31e2629c76d7f27dfca4e8f25de09ead7b" "a6b096b03219ebfb499c91b39f99f948603a5696" "eb549cd27606ec00631c0c736cd589afd5be73dd")
CROS_WORKON_TREE=("d10717cae9406b5c235d354502852d927981f26c" "aeafb75a49d49da27d8ecf43ce82b98df4610a6a" "7c8af5c14825c5737bb71f913e1e4e94a540dd3b")
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
