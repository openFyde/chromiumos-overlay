# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("130dae7aca8e035e689a4d46b469181fca3b7dfa" "1ee05bb6359ef64fac808b89913d769d48701966")
CROS_WORKON_TREE=("0ce22e56ed724479680a76eaff90163bd49ee942" "23b777e1f6484d49a5c08fd2321204fdb5bc8eb3")
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

DEPEND="
	chromeos-base/policy-go-proto
	chromeos-base/system_api
	dev-go/cdp
	dev-go/cmp
	dev-go/crypto
	dev-go/dbus
	dev-go/gopsutil
	dev-go/go-matroska
	dev-go/mdns
	dev-go/protobuf
	dev-go/selinux
	dev-go/yaml
"

RDEPEND="
	chromeos-base/tast-local-helpers-cros
	chromeos-base/wprgo
	dev-libs/openssl
	arc? ( dev-util/android-tools )
	dev-util/android-uiautomator-server
	net-misc/curl
	sys-apps/memtester
	usbip? ( chromeos-base/virtual-usb-printer )
"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
