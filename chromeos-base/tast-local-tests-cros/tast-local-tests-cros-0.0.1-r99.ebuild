# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("61ac86f0e649a3f1e87edacb7fb13d3511a81ee2" "7c00b77d1777460a28ce06223903984c29a1ac66")
CROS_WORKON_TREE=("f62f1e5509f1df14126db283b24822e6a60d9ce0" "439ad9b9f0daee358996a6f5629c6e9e8a866a26")
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
	# Test support packages that live above local/bundles/.
	"chromiumos/tast/local/..."
)

inherit cros-workon tast-bundle

DESCRIPTION="Bundle of local integration tests for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/system_api
	dev-go/cdp
	dev-go/dbus
	dev-go/gopsutil
	dev-go/protobuf
"
RDEPEND="!chromeos-base/tast-local-tests"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
