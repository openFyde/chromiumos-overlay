# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("6ddfcb3fa511a31eb06bc34d7fffe111bd2c2400" "0c804fe517c0c25f4ce56bedde45bb92b0e87a62")
CROS_WORKON_TREE=("11d2cb75d153aaa4a1fe3a480f81a4ac02697fac" "660c7c06fa944ce86d64d4c64301d90d8496bb87")
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
