# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("56d2a935aa987e80c76698c90ae1a176784b4431" "f5abe759b21de678d819f20ba0bfa1ee75d95dbd")
CROS_WORKON_TREE=("95f956fa8ee48f6044e06e1bef9cd6d3a26a448b" "51826c883f269484ec2f34ee4232020ca3f23ca1")
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
	chromeos-base/policy-testserver
	chromeos-base/tast-local-helpers-cros
	chromeos-base/wprgo
	dev-libs/openssl:0=
	arc? (
		dev-util/android-tools
		dev-util/android-uiautomator-server
	)
	net-misc/curl
	sys-apps/memtester
	sys-apps/rootdev
	virtual/udev
	usbip? ( chromeos-base/virtual-usb-printer )
"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
