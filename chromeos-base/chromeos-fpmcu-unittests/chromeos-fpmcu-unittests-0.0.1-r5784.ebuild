# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

# Increment the "eclass bug workaround count" below when you change
# "cros-ec.eclass" to work around http://crbug.com/220902.
#
# eclass bug workaround count: 2

EAPI=7

CROS_WORKON_COMMIT=("534ff5c3a9bc007b45cea61ea2d53f0f0291488d" "11a97df4133f905bbdf9ddb48b5d56d617ec949b")
CROS_WORKON_TREE=("6230364ee5f8d1855e6b31af759e8aea3e6a09d3" "cafc71cae4ef6b3e7e64648b257b3f0ca2300e1d")
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

inherit coreboot-sdk cros-ec cros-workon cros-sanitizers

DESCRIPTION="ChromeOS fingerprint MCU unittest binaries"
KEYWORDS="*"

# Make sure config tools use the latest schema.
BDEPEND=">=chromeos-base/chromeos-config-host-0.0.2"

get_target_boards() {
	# TODO(yichengli): Add other FPMCUs once the test lab has them.
	EC_BOARDS=("bloonchipper")
}

src_configure() {
	sanitizers-setup-env
	default
}

src_compile() {
	cros-ec_set_build_env
	get_target_boards

	# TODO(yichengli): Add other FPMCU boards once the test lab has them.
	# NOTE: Any changes here must also be reflected in
	# platform/ec/firmware_builder.py which is used for the ec cq
	local target
	einfo "Building FPMCU unittest binary for targets: ${EC_BOARDS[*]}"
	for target in "${EC_BOARDS[@]}"; do
		emake CROSS_COMPILE="${COREBOOT_SDK_PREFIX_arm}" BOARD="${target}" \
			"${EC_OPTS[@]}" clean
		emake CROSS_COMPILE="${COREBOOT_SDK_PREFIX_arm}" BOARD="${target}" \
			"${EC_OPTS[@]}" tests
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
