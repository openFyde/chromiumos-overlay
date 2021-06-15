# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="f34cf3a06f7b17b7829185630d886a5d9d3f0e75"
CROS_WORKON_TREE=("791c6808b4f4f5f1c484108d66ff958d65f8f1e3" "e3d4b675a41bab4b0a7d7f2cc58a3113f54af7fd" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
