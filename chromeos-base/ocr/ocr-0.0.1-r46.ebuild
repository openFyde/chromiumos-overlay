# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="53eb7dac34bd189fa74f7e18f11a939bdfd33a27"
CROS_WORKON_TREE=("a58d199d2c4d0e5da40bb5d453f513f5e2c97ae4" "9dbe561b4dba69a82e72fc834fa02d0bb8c701e2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk ocr .gn"
CROS_WORKON_OUTOFTREE_BUILD=1

PLATFORM_SUBDIR="ocr"

inherit cros-workon platform user

DESCRIPTION="Optical Character Recognition service for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/ocr/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	app-text/tesseract:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewuser ocr_service
	enewgroup ocr_service
}

src_install() {
	dobin "${OUT}"/ocr_service

	dobin "${OUT}"/ocr_tool

	# Install upstart configuration.
	insinto /etc/init
	doins init/ocr_service.conf

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.OpticalCharacterRecognition.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus_permissions/org.chromium.OpticalCharacterRecognition.service
}

platform_pkg_test() {
	local tests=(
		"ocr_service_test"
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
