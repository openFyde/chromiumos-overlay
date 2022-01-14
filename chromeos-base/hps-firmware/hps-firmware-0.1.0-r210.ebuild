# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="90414e0ce701eadf1eeb99ae8b940ae21c73c36d"
CROS_WORKON_TREE="05b67e45fb1d9462da96138dbe00d817984d1424"
inherit cros-workon cros-rust

CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware"
CROS_WORKON_LOCALNAME="platform/hps-firmware2"

DESCRIPTION="HPS firmware and tooling"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware"

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="
	dev-rust/svd2rust
	sci-electronics/litespi
	sci-electronics/litex
	sci-electronics/nextpnr
	sci-electronics/nmigen
	sci-electronics/prjoxide
	sci-electronics/pythondata-cpu-vexriscv
	sci-electronics/yosys
"

DEPEND="
	>=dev-rust/anyhow-1.0.38:= <dev-rust/anyhow-2.0.0
	>=dev-rust/bayer-0.1.5 <dev-rust/bayer-0.2.0_alpha:=
	>=dev-rust/bitflags-1.3.2:= <dev-rust/bitflags-2.0.0
	=dev-rust/clap-3*:=
	=dev-rust/colored-2*:=
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
	>=dev-rust/image-0.23.14:= <dev-rust/image-0.24
	>=dev-rust/num_enum-0.5.1:= <dev-rust/num_enum-0.6.0
	=dev-rust/panic-halt-0.2*:=
	=dev-rust/panic-reset-0.1*:=
	>=dev-rust/rusb-0.8.1:= <dev-rust/rusb-0.9
	=dev-rust/rustyline-9*:=
	>=dev-rust/serialport-4.0.1:= <dev-rust/serialport-5
	>=dev-rust/spi-memory-0.2.0:= <dev-rust/spi-memory-0.3.0
	=dev-rust/stm32g0xx-hal-0.1*:=
	=dev-rust/ufmt-0.1*:=
	=dev-rust/ufmt-write-0.1*:=
	>=dev-rust/panic-rtt-target-0.1.2:= <dev-rust/panic-rtt-target-0.2.0
	>=dev-rust/rtt-target-0.3.1:= <dev-rust/rtt-target-0.4.0
	chromeos-base/hps-firmware-images:=
"

# /usr/lib/firmware/hps/fpga_bitstream.bin moved from hps-firmware-images to here
RDEPEND="
	!<chromeos-base/hps-firmware-images-0.0.1-r7
"

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

	# Delete some optional dependencies that are not packaged in Chromium OS.
	sed -i \
		-e '/ optional = true/d' \
		-e '/^daemon = /d' \
		-e '/^ftdi = /d' \
		rust/hps-util/Cargo.toml
	sed -i \
		-e '/ optional = true/d' \
		-e '/^direct /d' \
		rust/hps-mon/Cargo.toml

	default
}

src_configure() {
	# CROS_BASE_RUSTFLAGS are for the AP, they are not applicable to
	# HPS firmware, which is cross-compiled for STM32
	unset CROS_BASE_RUSTFLAGS
	cros-rust_configure_cargo

	# Override some unwanted rustflags configured by cros-rust_configure_cargo.
	# For our Cortex-M0 target, we need "fat" LTO and opt-level=z (smallest) to
	# make everything small enough to fit. Debug assertions and
	# integer overflow checks introduce panicking paths into the firmware,
	# which bloats the size of the images with extra strings in .rodata.
	# TODO(dcallagh): tidy this up properly in cros-rust.eclass.
	# CROS_BASE_RUSTFLAGS are the same problem.
	# asan and ubsan are also the same problem.
	cat <<- EOF >> "${ECARGO_HOME}/config"
	[target.'cfg(all(target_arch = "arm", target_os = "none"))']
	rustflags = [
		"-Clto=yes",
		"-Copt-level=z",
		"-Coverflow-checks=off",
		"-Cdebug-assertions=off",
	]
	EOF
}

src_compile() {
	# Build FPGA bitstream
	einfo "Building FPGA bitstream"
	python -m soc.hps_soc --build --no-compile-software || die

	# Build userspace tools
	for tool in hps-mon hps-util sign-rom ; do (
		cd rust/${tool} || die
		einfo "Building ${tool}"
		ecargo_build
	) done

	# Also build signing tool for the build host, so that we can use it below
	if [ "${CBUILD}" != "${CHOST}" ] ; then
		(
			cd rust/sign-rom || die
			einfo "Building sign-rom for build host"
			ecargo build --target="${CBUILD}" --release
		)
	fi

	# Build MCU firmware
	for crate in stage0 stage1_app ; do (
		einfo "Building MCU firmware ${crate}"
		cd rust/mcu/${crate} || die
		HPS_SPI_BIT="${S}/build/hps_platform/gateware/hps_platform.bit" \
			HPS_SPI_BIN="${SYSROOT}/usr/lib/firmware/hps/fpga_application.bin" \
			ecargo build \
			--target="thumbv6m-none-eabi" \
			--release
		einfo "Flattening MCU firmware image ${crate}"
		llvm-objcopy -O binary \
			"${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/${crate}" \
			"${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/${crate}.bin" || die
	) done

	# Sign MCU stage1 firmware with dev key
	"${CARGO_TARGET_DIR}/${CBUILD}/release/sign-rom" \
		--input "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin" \
		--output "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin.signed" \
		|| die
}

src_test() {
	# TODO invoke ecargo_test once we have complete workspace deps satisfied
	:
}

src_install() {
	newbin "$(cros-rust_get_build_dir)/sign-rom" hps-sign-rom
	dobin "$(cros-rust_get_build_dir)/hps-mon"
	dobin "$(cros-rust_get_build_dir)/hps-util"

	insinto "/usr/lib/firmware/hps"
	newins "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage0.bin" "mcu_stage0.bin"
	newins "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin.signed" "mcu_stage1.bin"
	newins build/hps_platform/gateware/hps_platform.bit fpga_bitstream.bin
	doins build/hps_platform/gateware/hps_platform_build.metadata
}
