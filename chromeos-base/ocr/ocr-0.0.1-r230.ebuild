# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="5bb50e408234f67b356c782c8cac6497208d1697"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "b55b3d4e25d6b2c6c15710b7b56f06f7e581d08b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	platform_src_install

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
