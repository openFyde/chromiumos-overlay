# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("633ee552a5ffbea71e1240a824049e679f404ef3" "b359c8c06c20a9a82842e4b9e59d6e797d1ec486")
CROS_WORKON_TREE=("481a5a063842d21c8d6740b482efb489f34f1449" "a227dd0e8e119a97d6285e93fecf8aacef77c625")
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

# The URLs listed here must match those in files/external_data.conf.
TAST_BUNDLE_EXTERNAL_DATA_URLS=(
	"gs://chromiumos-test-assets-public/tast/cros/arcapp/media_session_60sec_test_20180919.ogg"
	"gs://chromiumos-test-assets-public/tast/cros/arcapp/media_session_test_20181101.apk"
	"gs://chromiumos-test-assets-public/tast/cros/arcapp/todo-mvp-20180814.apk"
	"gs://chromiumos-test-assets-public/tast/cros/debugd/debugd_printer_GenericPostScript_20181001.ppd.gz"
	"gs://chromiumos-test-assets-public/tast/cros/example/data_files_external_20180626.txt"
	"gs://chromiumos-test-assets-public/tast/cros/meta/local_files_external_20180811.txt"
	"gs://chromiumos-test-assets-public/tast/cros/printer/printer_add_epson_printer_EpsonWF3620_20181113.ppd"
	"gs://chromiumos-test-assets-public/tast/cros/printer/printer_add_epson_printer_golden_20181113.ps"
	"gs://chromiumos-test-assets-public/tast/cros/printer/printer_add_generic_printer_GenericPostScript_20181031.ppd.gz"
	"gs://chromiumos-test-assets-public/tast/cros/printer/printer_add_generic_printer_golden_20181031.ps"
	"gs://chromiumos-test-assets-public/tast/cros/printer/to_print_20181031.pdf"
	"gs://chromiumos-test-assets-public/tast/cros/video/bali_640x360_P420_20181113.yuv"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear_320x192_40frames_20181020.nv12.yuv"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear_320x192_40frames_20181020.yuv"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear_h264_320x180_20180629.mp4"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear_vp8_320x180_20180629.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear_vp9_320x240_20180629.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/crowd-1920x1080_20181103.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/peach_pi-1280x720_20181105.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/peach_pi-40x23_20181109.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/peach_pi-41x22_20181109.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/peach_pi-41x23_20181109.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/pixel-1280x720_20181109.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/tulip2-1280x720_20181103.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/tulip2-320x180_20181103.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/tulip2-640x360_20181103.webm"
	"gs://chromiumos-test-assets-public/traffic/traffic-1920x1080-8005020218f6b86bfa978e550d04956e.mp4"
)

inherit cros-workon tast-bundle

DESCRIPTION="Bundle of local integration tests for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/"

LICENSE="Apache-2.0 BSD-Google"
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
	dev-go/yaml
"
RDEPEND="
	!chromeos-base/tast-local-tests
	dev-util/android-uiautomator-server
"

# Permit files/external_data.conf to pull in files that are located in
# gs://chromiumos-test-assets-public.
RESTRICT=nomirror
