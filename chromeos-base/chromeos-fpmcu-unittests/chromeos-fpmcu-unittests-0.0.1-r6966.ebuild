# Copyright 2020 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE.makefile file.

# Increment the "eclass bug workaround count" below when you change
# "cros-ec.eclass" to work around https://issuetracker.google.com/201299127.
#
# eclass bug workaround count: 5

EAPI=7

CROS_WORKON_COMMIT=("49a4b42d98ae57d7f3beb9caa7a3e6ade599113d" "0dd679081b9c8bfa2583d74e3a17a413709ea362" "3564668908afc66351c1c3cc47dca2fcdb91dc12")
CROS_WORKON_TREE=("0515710dc27c3015e353ac5101a1be4c4a5df539" "d99abee3f825248f344c0638d5f9fcdce114b744" "0797c8b1cea2a671b81642618c279994d2275cc6")
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
