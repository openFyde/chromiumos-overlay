# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("9cb5b69026958274bb1b543d8990a97db16a3995" "a977eb6931b89c52554406e2b4cdb913247293c3")
CROS_WORKON_TREE=("ee9f927649f9c316b928f39d7eb3c6b79854c313" "55b9244e3dd28cf60acdc19de4cb19d844d3700d")
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
	"gs://chromiumos-test-assets-public/tast/cros/example/data_files_external_20180626.txt"
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
"
RDEPEND="!chromeos-base/tast-local-tests"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
