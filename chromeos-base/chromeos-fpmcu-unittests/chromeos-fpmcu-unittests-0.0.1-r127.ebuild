# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

# Increment the "eclass bug workaround count" below when you change
# "cros-ec.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 1

EAPI=7

CROS_WORKON_COMMIT=("01b7d964e5afe94450548c05ca062c35ac5fdd89" "1e2e9d7183f545eefd1a86a07b0ab6f91d837a6c")
CROS_WORKON_TREE=("16689abd6fcdadcc122adbd024508ea58e28bd2b" "fdbc51bbd5a7ee9d532ea1aa30cf21e57ca199db")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/cryptoc"
)
CROS_WORKON_LOCALNAME=(
	"platform/ec"
	"third_party/cryptoc"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/cryptoc"
)

inherit coreboot-sdk cros-ec cros-workon

DESCRIPTION="ChromeOS fingerprint MCU unittest binaries"
KEYWORDS="*"

# Make sure config tools use the latest schema.
BDEPEND=">=chromeos-base/chromeos-config-host-0.0.2"

get_target_boards() {
	# TODO(yichengli): Add other FPMCUs once the test lab has them.
	EC_BOARDS=("bloonchipper")
}

src_compile() {
	cros-ec_set_build_env
	get_target_boards

	# TODO(yichengli): Add other FPMCU boards once the test lab has them.
	local target
	einfo "Building FPMCU unittest binary for targets: ${EC_BOARDS[*]}"
	for target in "${EC_BOARDS[@]}"; do
		emake CROSS_COMPILE="${COREBOOT_SDK_PREFIX_arm}" BOARD="${target}" \
			"${EC_OPTS[@]}" clean
		emake CROSS_COMPILE="${COREBOOT_SDK_PREFIX_arm}" BOARD="${target}" \
			"${EC_OPTS[@]}" test-rsa
	done
}

src_install() {
	local target
	for target in "${EC_BOARDS[@]}"; do
		insinto /firmware/chromeos-fpmcu-unittests/"${target}"
		doins build/"${target}"/*.bin
	done
}

# Do not run cros-ec's tests.
src_test() {
	:
}
