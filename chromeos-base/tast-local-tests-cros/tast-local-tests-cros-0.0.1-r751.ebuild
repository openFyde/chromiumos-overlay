# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("402f52ee0840a788fb28b3830f05cb491c0ae97e" "99afa9773cff98052bafb0a329f09b368b30e648")
CROS_WORKON_TREE=("947f21cd8312bb5c7451096b4218ab7df08aec09" "c0b149c8bc0daa71c83114a914ad070177c546a2")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/tast-tests"
	"chromiumos/platform/tast"
)
CROS_WORKON_LOCALNAME=(
	"tast-tests"
	"tast"
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
	"chromiumos/tast/local/..."
)
CROS_GO_VET=(
	"${CROS_GO_TEST[@]}"
)

inherit cros-workon tast-bundle

DESCRIPTION="Bundle of local integration tests for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/"

LICENSE="Apache-2.0 BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="arc usbip"

# Build-time dependencies should be added to tast-build-deps, not here.
DEPEND="chromeos-base/tast-build-deps"

RDEPEND="
	chromeos-base/tast-local-helpers-cros
	chromeos-base/wprgo
	dev-libs/openssl
	arc? (
		dev-util/android-tools
		dev-util/android-uiautomator-server
	)
	net-misc/curl
	sys-apps/memtester
	usbip? ( chromeos-base/virtual-usb-printer )
"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
