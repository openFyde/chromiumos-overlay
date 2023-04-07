# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("19f464ace22ead9a8d49e71b39ec3ea0e977c197" "8bf91dcb82207edbef19e04c231f81de3154c126")
CROS_WORKON_TREE=("16253879ab5f9dd507cb8f6d2e8191b68f93270c" "672a43291d03f8be9547677d116210f183a6818b")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/tast-tests"
	"chromiumos/platform/tast"
)
CROS_WORKON_LOCALNAME=(
	"platform/tast-tests"
	"platform/tast"
)
CROS_WORKON_DESTDIR=(
	"${S}"
	"${S}/tast-base"
)

CROS_GO_WORKSPACE=(
	"${CROS_WORKON_DESTDIR[@]}"
)

CROS_GO_TEST=(
	# Also test support packages that live above local/bundles/.
	"chromiumos/tast/..."
	"go.chromium.org/tast/..."
)
CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

TAST_BUNDLE_EXCLUDE_DATA_FILES="1"

inherit cros-workon tast-bundle

DESCRIPTION="Bundle of local integration tests for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/"

LICENSE="Apache-2.0 BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="arc chromeless_tty chromeless_tests cups"

# Build-time dependencies should be added to tast-build-deps, not here.
DEPEND="chromeos-base/tast-build-deps:="

RDEPEND="
	chromeos-base/tast-local-helpers-cros
	chromeos-base/tast-tests-local-data
	chromeos-base/virtual-usb-printer
	chromeos-base/wprgo
	!chromeless_tty? (
		!chromeless_tests? (
			chromeos-base/drm-tests
		)
	)
	dev-libs/openssl:0=
	dev-python/pyftdi
	arc? (
		chromeos-base/tast-local-apks-cros
		dev-util/android-tools
		dev-util/android-uiautomator-server
	)
	net-misc/curl
	cups? (
		net-print/ippsample
	)
	sys-apps/memtester
	sys-apps/rootdev
	virtual/udev
"
