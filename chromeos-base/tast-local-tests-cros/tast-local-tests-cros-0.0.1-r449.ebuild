# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("98ebae79a2ed739c5810954584b0412c1e91f5b1" "c2b2b6d573c9c3e5c1f81935d10f06216644bd04")
CROS_WORKON_TREE=("0cb3a6b56fd9848fd2e530bcfcd7bdf0da8250cc" "a08c3f566328cd5d38047d201a19af4360728e55")
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
IUSE="usbip"

DEPEND="
	chromeos-base/policy-go-proto
	chromeos-base/system_api
	dev-go/cdp
	dev-go/cmp
	dev-go/crypto
	dev-go/dbus
	dev-go/gopsutil
	dev-go/mdns
	dev-go/protobuf
	dev-go/selinux
	dev-go/yaml
"
RDEPEND="
	chromeos-base/security_tests
	chromeos-base/wprgo
	dev-libs/openssl
	dev-util/android-uiautomator-server
	net-misc/curl
	usbip? ( chromeos-base/virtual-usb-printer )
"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
