# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="09108c6d99c39dd10bb42991874d6e59ad177331"
CROS_WORKON_TREE=("d4c46f75f6620ba5bf8f25c12db0b85b5839ea54" "0c136b06d2fa32a925d3a5374eb12f1f1281ee3a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
IUSE="fuzzer"

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

	# Install upstart configuration except for fuzzer builds.
	insinto /etc/init
	use fuzzer || doins init/ocr_service.conf

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.OpticalCharacterRecognition.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus_permissions/org.chromium.OpticalCharacterRecognition.service

	# Install the fuzzer
	local comp="860616"
	platform_fuzzer_install "${S}/OWNERS" "${OUT}/ocr_service_fuzzer" \
		--comp "${comp}"
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
