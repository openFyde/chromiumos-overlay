# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT=("f4f6bbe60eeb64e9d9af9302bc3e5f76e04ba3e5" "8247fde1b98ac616292aba1a3e0e28ee70fe55bb")
CROS_WORKON_TREE=("40297b5500a3015ff19fa650b591828bd314a8e9" "68a1d22ab44f0ecb0dbcc15030251e7dcca8dd1c")
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
	"gs://chromiumos-test-assets-public/tast/cros/printer/printer_add_generic_printer_golden_20181120.ps"
	"gs://chromiumos-test-assets-public/tast/cros/printer/to_print_20181031.pdf"
	"gs://chromiumos-test-assets-public/tast/cros/session/testcert_20181121.p12"
	"gs://chromiumos-test-assets-public/tast/cros/video/bali_640x360_P420_20181113.yuv"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x240-audio-only_20181120.aac.mp4"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x240-audio-only_20181120.opus.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x240-audio-only_20181120.vorbis.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x240-video-only_20181120.h264.mp4"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x240-video-only_20181120.vp8.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x240-video-only_20181120.vp9.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x240_20181120.h264.mp4"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x240_20181120.vp8.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x240_20181120.vp9.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/bear-320x192_20181120.vp9.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/crowd-1920x1080_20181120.vp9.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/peach_pi-1280x720_20181105.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/peach_pi-40x23_20181109.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/peach_pi-41x22_20181109.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/peach_pi-41x23_20181109.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/pixel-1280x720_20181109.jpg"
	"gs://chromiumos-test-assets-public/tast/cros/video/tulip2-1280x720_20181120.vp9.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/tulip2-320x180_20181120.vp9.webm"
	"gs://chromiumos-test-assets-public/tast/cros/video/tulip2-640x360_20181120.vp9.webm"
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
