# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("92e05d49c8e025671744ab8a98af13868040d79a" "e233d09a4e62493e7601054169d479e5c77b6f95" "54e3e09fc6c98b2280269d70de2f4b0e083d476a")
CROS_WORKON_TREE=("988025d291bc2f8c70c472daf4c35f4615affb26" "ede4f192e0f9babff61beafca3bc1c235b2d5c2b" "55c0bad7529728ced1b1b31eda099ff1846aa1fe")
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
