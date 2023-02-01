# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

# Increment the "eclass bug workaround count" below when you change
# "cros-ec.eclass" to work around https://issuetracker.google.com/201299127.
#
# eclass bug workaround count: 5

EAPI=7

CROS_WORKON_COMMIT=("a634477861c3fb0bb7411023d9657a121ccbbc89" "0dd679081b9c8bfa2583d74e3a17a413709ea362" "4be6a458acc129b10faf88aeb2fc32f0444eefb1")
CROS_WORKON_TREE=("d2fabddaddff572709d5e5de74bb5a86c94da1d9" "d99abee3f825248f344c0638d5f9fcdce114b744" "19e8cc93fb42b27386df03756edbd264238d34fa")
CROS_WORKON_PROJECT=(
	"chromiumos/platform/ec"
	"chromiumos/third_party/cryptoc"
	"external/gitlab.com/libeigen/eigen"
)
CROS_WORKON_LOCALNAME=(
	"platform/ec"
	"third_party/cryptoc"
	"third_party/eigen3"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform/ec"
	"${S}/third_party/cryptoc"
	"${S}/third_party/eigen3"
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
		emake BOARD="${target}" "${EC_OPTS[@]}" clean
		emake BOARD="${target}" "${EC_OPTS[@]}" tests
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
