# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("c547c36698357c9bc3bf16213d93068f6f26fcbb" "f1df3d2d3b78466ec10bcb5408e58c2ecc927d61")
CROS_WORKON_TREE=("05567eaf9128a6ac38b1e1a0ba9f03ac41f3ce13" "448b7e39b3b5a929f8d7a897679167bf3f9519e0")
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
