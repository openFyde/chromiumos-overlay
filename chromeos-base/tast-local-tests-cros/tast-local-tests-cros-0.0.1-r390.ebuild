# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("05d83345f4c649df25fc66f28e4920d74e9bdc69" "8eb89d0b1bbddeb1c024a29870de1cbcba61df7e")
CROS_WORKON_TREE=("f6e9a21239cc1e044909a4d9b58c51b4af329ac6" "6ad7ded28eb862ed585269986625da6d71811b43")
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
IUSE=""

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
	!chromeos-base/tast-local-tests
	chromeos-base/security_tests
	dev-util/android-uiautomator-server
"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
