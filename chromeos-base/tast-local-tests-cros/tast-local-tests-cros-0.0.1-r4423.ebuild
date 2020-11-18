# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("e22f49acbcd0d43be1f979969c3107d33c7b8b36" "21230bf407eb2268876a099bfe51ce3cc60755f3")
CROS_WORKON_TREE=("80602bb0b6d69efc591ea77c1f80d112d816f08e" "c7361d3d9ff5fd4332acd45a5e95110a4b3bb4db")
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

inherit cros-workon tast-bundle

DESCRIPTION="Bundle of local integration tests for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/"

LICENSE="Apache-2.0 BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="arc chromeless_tty chromeless_tests kernel-3_8 kernel-3_10 kernel-3_14"

# Build-time dependencies should be added to tast-build-deps, not here.
DEPEND="chromeos-base/tast-build-deps:="

RDEPEND="
	chromeos-base/policy-testserver
	chromeos-base/tast-local-helpers-cros
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
	sys-apps/memtester
	sys-apps/rootdev
	virtual/udev
	!kernel-3_14? (
		!kernel-3_10? (
			!kernel-3_8? (
				chromeos-base/virtual-usb-printer
			)
		)
	)
"
