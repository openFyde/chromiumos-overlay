# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("cff6594ff5344d347bdb48aa7ef81fda92baff67" "95c1c83b320446f331367f8038c68caea0e153ff")
CROS_WORKON_TREE=("567a499a253faee553230e0f0323450880533d5a" "5ee5c6d1d2ec655e4bb73c8fa2e181aa03650805")
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

# The URLs listed here must match those in files/external_data.conf.
TAST_BUNDLE_EXTERNAL_DATA_URLS=(
	"gs://chromiumos-test-assets-public/tast/cros/arcapp/todo-mvp-20180814.apk"
	"gs://chromiumos-test-assets-public/tast/cros/example/data_files_external_20180626.txt"
	"gs://chromiumos-test-assets-public/tast/cros/meta/local_files_external_20180811.txt"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear_h264_320x180_20180629.mp4"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear_vp8_320x180_20180629.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear_vp9_320x240_20180629.webm"
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
	dev-go/selinux
"
RDEPEND="
	!chromeos-base/tast-local-tests
	dev-util/android-uiautomator-server
"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
