# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("803a312fbace5765342a2e750c06e1c40db3efd7" "0cd34aa8fedae223a7e756f75edc6e1bcefc07d4")
CROS_WORKON_TREE=("1eef0b75e4136c15f1778de0910dfc777f216538" "7d2e2d9ec16bcb178a715a2442a1901cfbea84c5")
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
	chromeos-base/policy-testserver
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
