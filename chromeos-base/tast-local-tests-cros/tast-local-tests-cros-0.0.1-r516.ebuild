# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("fd7836fc9c282cf77b20f0553976d033a6b85e58" "20c6b05dacb147a9454393316e8fc16640910004")
CROS_WORKON_TREE=("10f0458a2bfcb37197314539679cfbbe597c12c3" "7dc5003dc7dad7a9fb26a0a9c69d00cbfceebeef")
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
# TODO(derat): Remove graphics_tests and security_tests after all tests have
# been updated to use files installed by tast-local-helpers-cros instead.
RDEPEND="
	chromeos-base/graphics_tests
	chromeos-base/security_tests
	chromeos-base/tast-local-helpers-cros
	chromeos-base/wprgo
	dev-libs/openssl
	dev-util/android-uiautomator-server
	net-misc/curl
	sys-apps/memtester
	usbip? ( chromeos-base/virtual-usb-printer )
"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
