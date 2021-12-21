# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="300adf896edf2ac5133a8c50a96a54be47a456eb"
CROS_WORKON_TREE="1dabdeec8b424b791d4bd3d79759d9152815638f"
inherit cros-workon cros-rust

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware"
CROS_WORKON_LOCALNAME="platform/hps-firmware2"

DESCRIPTION="HPS firmware and tooling"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware"

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="dev-libs/openssl"

# Add these for hps-mon / hps-util:
	#>=dev-rust/argh-0.1.4:= <dev-rust/argh-0.2.0
	#=dev-rust/ftd2xx-embedded-hal-0.7*:=
	#>=dev-rust/serialport-4.0.1:= <dev-rust/serialport-5.0.0

DEPEND="
	>=dev-rust/anyhow-1.0.38:= <dev-rust/anyhow-2.0.0
	>=dev-rust/bitflags-1.3.2:= <dev-rust/bitflags-2.0.0
	=dev-rust/clap-3*:=
	>=dev-rust/cortex-m-0.7.1:= <dev-rust/cortex-m-0.8.0
	>=dev-rust/cortex-m-rt-0.6.13:= <dev-rust/cortex-m-rt-0.7.0
	>=dev-rust/cortex-m-rtic-0.5.5:= <dev-rust/cortex-m-rtic-0.6.0
	=dev-rust/crc-2*:=
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
	>=dev-rust/panic-rtt-target-0.1.2:= <dev-rust/panic-rtt-target-0.2.0
	>=dev-rust/rtt-target-0.3.1:= <dev-rust/rtt-target-0.4.0
	chromeos-base/hps-firmware-images:=
"

# Integer overflow checks introduce panicking paths into the firmware,
# which bloats the size of the images with extra strings in .rodata.
CROS_RUST_OVERFLOW_CHECKS=0

src_unpack() {
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_prepare() {
	# Not using cros-rust_src_prepare because it wrongly assumes Cargo.toml is
	# in the root of ${S} and we don't need its manipulations anyway.

	# Delete the top-level workspace Cargo.toml. This avoids build breakages if
	# that workspace, which includes various development tools not built in
	# ChromeOS, uses dependencies for which we don't yet have ebuilds. We don't
	# currently delete rust/mcu/Cargo.toml, since it includes the optimization
	# settings used for stage0 and stage1_app.
	rm rust/Cargo.toml rust/riscv/Cargo.toml

	default
}

src_configure() {
	# CROS_BASE_RUSTFLAGS are for the AP, they are not applicable to
	# HPS firmware, which is cross-compiled for STM32
	unset CROS_BASE_RUSTFLAGS
	cros-rust_configure_cargo

	# Override some unwanted rustflags configured by cros-rust_configure_cargo.
	# TODO(dcallagh): tidy this up properly in cros-rust.eclass.
	# CROS_BASE_RUSTFLAGS are the same problem.
	# asan and ubsan are also the same problem.
	cat <<- EOF >> "${ECARGO_HOME}/config"
	[target.'cfg(all(target_arch = "arm", target_os = "none"))']
	rustflags = [ "-Clto=yes", "-Copt-level=z" ]
	EOF
}

src_compile() {
	# Build userspace tools
	for tool in sign-rom ; do (
		cd rust/${tool} || die
		einfo "Building ${tool}"
		ecargo_build
	) done

	# Build MCU firmware
	for crate in stage0 stage1_app ; do (
		einfo "Building MCU firmware ${crate}"
		cd rust/mcu/${crate} || die
		HPS_SPI_BIT="${SYSROOT}/usr/lib/firmware/hps/fpga_bitstream.bin" \
			HPS_SPI_BIN="${SYSROOT}/usr/lib/firmware/hps/fpga_application.bin" \
			ecargo build \
			--target="thumbv6m-none-eabi" \
			--release
		einfo "Flattening MCU firmware image ${crate}"
		llvm-objcopy -O binary \
			"${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/${crate}" \
			"${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/${crate}.bin" || die
	) done

	# Put something in the signature / version bytes. These will be overwritten
	# when the binary gets signed, but are useful for development.
	openssl dgst -md5 -binary \
		"${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin" \
		| dd bs=1 seek=20 count=4 conv=notrunc \
		of="${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin" \
		|| die
}

src_test() {
	# TODO invoke ecargo_test once we have complete workspace deps satisfied
	:
}

src_install() {
	newbin "$(cros-rust_get_build_dir)/sign-rom" hps-sign-rom

	insinto "/usr/lib/firmware/hps"
	newins "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage0.bin" "mcu_stage0.bin"
	newins "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin" "mcu_stage1.bin"
}
