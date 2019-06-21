# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("ee3c96d10fd8d5113e95cb2321d88d4415b16465" "de2130fc2268fd54f01206d728cd40fe9dd922aa")
CROS_WORKON_TREE=("7b3c3d14274933e63d73a26ec618a802c5857640" "e9db09b350c567cce81f99a645c4935a1a0b6e8a")
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
