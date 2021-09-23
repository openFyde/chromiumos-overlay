# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="7a6e5eccda498051f251a4e8482eb008542aff7c"
CROS_WORKON_TREE="c47bd0ecff78474ad700f1c78c0a4b2c604e6b31"
inherit cros-workon cros-rust

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware"
CROS_WORKON_LOCALNAME="platform/hps-firmware2"

DESCRIPTION="HPS firmware and tooling"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware"

LICENSE="BSD-Google"
KEYWORDS="*"

# Add these for hps-mon / hps-util:
	#>=dev-rust/argh-0.1.4:= <dev-rust/argh-0.2.0
	#=dev-rust/ftd2xx-embedded-hal-0.7*:=
	#>=dev-rust/serialport-4.0.1:= <dev-rust/serialport-5.0.0

# Add these for stm32g0_application:
	#=dev-rust/crc-2*:=
	#>=dev-rust/panic-rtt-target-0.1.2:= <dev-rust/panic-rtt-target-0.2.0
	#>=dev-rust/rtt-target-0.3.1:= <dev-rust/rtt-target-0.4.0
DEPEND="
	>=dev-rust/anyhow-1.0.38:= <dev-rust/anyhow-2.0.0
	>=dev-rust/bitflags-1.2.1:= <dev-rust/bitflags-2.0.0
	=dev-rust/clap-3*:=
	>=dev-rust/cortex-m-0.7.1:= <dev-rust/cortex-m-0.8.0
	>=dev-rust/cortex-m-rt-0.6.13:= <dev-rust/cortex-m-rt-0.7.0
	>=dev-rust/cortex-m-rtic-0.5.5:= <dev-rust/cortex-m-rtic-0.6.0
	>=dev-rust/defmt-0.2.1:= <dev-rust/defmt-0.3.0
	=dev-rust/defmt-rtt-0.2*:=
	>=dev-rust/ed25519-compact-0.1.9:= <dev-rust/ed25519-compact-0.2.0
	>=dev-rust/embedded-hal-0.2.4:= <dev-rust/embedded-hal-0.3.0
	=dev-rust/embedded-hal-mock-0.8*:=
	>=dev-rust/git-version-0.3.4:= <dev-rust/git-version-0.4.0
	>=dev-rust/hmac-sha256-0.1.6:= <dev-rust/hmac-sha256-0.2.0
	>=dev-rust/num_enum-0.5.1:= <dev-rust/num_enum-0.6.0
	=dev-rust/panic-halt-0.2*:=
	=dev-rust/panic-reset-0.1*:=
	>=dev-rust/spi-memory-0.2.0:= <dev-rust/spi-memory-0.3.0
	=dev-rust/stm32g0xx-hal-0.1*:=
	=dev-rust/ufmt-0.1*:=
	=dev-rust/ufmt-write-0.1*:=
"
RDEPEND="${DEPEND}"

src_unpack() {
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_prepare() {
	# Not using cros-rust_src_prepare because it wrongly assumes Cargo.toml is
	# in the root of ${S} and we don't need its manipulations anyway.

	# We need to hide some crates from cargo because they still have
	# unsatisfied dependencies, they can be added later.
	sed -i -e '/hps-util/d' -e '/hps-mon/d' -e '/debug_logger/d' -e '/factory_tester_mcu/d' -e '/mcp2221/d' mcu_rom/Cargo.toml

	default
}

src_configure() {
	# CROS_BASE_RUSTFLAGS are for the AP, they are not applicable to
	# HPS firmware, which is cross-compiled for STM32
	unset CROS_BASE_RUSTFLAGS
	cros-rust_configure_cargo

	# HPS userspace tools will be built for $CHOST (i.e. the Chromebook)
	# but we also need to build firmware for the STM32 inside HPS,
	# so we add that target to the generated cargo config.
	# shellcheck disable=SC2154
	cat <<- EOF >> "${ECARGO_HOME}/config"
	[target.thumbv6m-none-eabi]
	linker = "arm-none-eabi-ld" # Cortex-M0 and Cortex-M0+
	rustflags = [
		   # !!CAREFUL!! link.x is an internally generated linker script
		   # that will include 'memory.x' in the src root. Changing this
		   # will result in mysteriously broken binaries and you will be sad.
		   "-C", "link-arg=-Tlink.x",
		   "-C", "link-arg=-Tdefmt.x",
		   # An additional linker script for any HPS-specific linker directives.
		   "-C", "link-arg=-T../hps-common-link.x",
	]
	EOF
}

src_compile() {
	# Build userspace tools
	for tool in sign-rom ; do (
		cd mcu_rom/${tool} || die
		einfo "Building ${tool}"
		ecargo_build
	) done

	# Build MCU firmware
	for crate in stage0 stage1 ; do (
		einfo "Building MCU firmware ${crate}"
		cd mcu_rom/${crate} || die
		ecargo build \
			--target="thumbv6m-none-eabi" \
			--release
	) done
}

src_test() {
	# TODO invoke ecargo_test once we have complete workspace deps satisfied
	:
}

src_install() {
	newbin "$(cros-rust_get_build_dir)/sign-rom" hps-sign-rom

	insinto "/usr/lib/firmware/hps"
	newins "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage0" "mcu_stage0.elf"
	newins "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1" "mcu_stage1.elf"
}
