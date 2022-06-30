# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="449038cc0e6f6965581757c83661f045bc9b8cf7"
CROS_WORKON_TREE="4368a7fa40e53407d4e158cb159eac711508856f"
CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware"
CROS_WORKON_LOCALNAME="platform/hps-firmware2"
CROS_WORKON_USE_VCSID=1
PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon cros-rust toolchain-funcs python-any-r1

DESCRIPTION="HPS firmware and tooling"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware"

LICENSE="BSD-Google"
KEYWORDS="*"

BDEPEND="
	dev-embedded/hps-sdk
	dev-rust/svd2rust
	>=sci-electronics/nextpnr-0.1_p20220210
	sci-electronics/nmigen
	sci-electronics/prjoxide
	sci-electronics/yosys
	$(python_gen_any_dep '
		sci-electronics/litespi[${PYTHON_USEDEP}]
		sci-electronics/litex[${PYTHON_USEDEP}]
		sci-electronics/pythondata-cpu-vexriscv[${PYTHON_USEDEP}]
	')
"

python_check_deps() {
	has_version -b "sci-electronics/litespi[${PYTHON_USEDEP}]" &&
		has_version -b "sci-electronics/litex[${PYTHON_USEDEP}]" &&
		has_version -b "sci-electronics/pythondata-cpu-vexriscv[${PYTHON_USEDEP}]"
}

DEPEND="
	>=dev-rust/anyhow-1.0.38:= <dev-rust/anyhow-2.0.0
	>=dev-rust/bayer-0.1.5 <dev-rust/bayer-0.2.0_alpha:=
	=dev-rust/bindgen-0.59*
	>=dev-rust/bitflags-1.3.2:= <dev-rust/bitflags-2.0.0
	=dev-rust/clap-3.0.0_beta2:=
	=dev-rust/colored-2*:=
	>=dev-rust/cortex-m-0.6.2:= <dev-rust/cortex-m-0.7.0
	>=dev-rust/cortex-m-rt-0.6.13:= <dev-rust/cortex-m-rt-0.7.0
	>=dev-rust/cortex-m-rtic-0.5.5:= <dev-rust/cortex-m-rtic-0.6.0
	=dev-rust/crc-2*:=
	>=dev-rust/defmt-0.2.1:= <dev-rust/defmt-0.3.0
	=dev-rust/defmt-rtt-0.2*:=
	=dev-rust/ed25519-compact-1*:=
	>=dev-rust/embedded-hal-0.2.4:= <dev-rust/embedded-hal-0.3.0
	=dev-rust/embedded-hal-mock-0.8*:=
	>=dev-rust/hmac-sha256-0.1.6:= <dev-rust/hmac-sha256-0.2.0
	>=dev-rust/image-0.23.14:= <dev-rust/image-0.24
	>=dev-rust/indicatif-0.16.2:= <dev-rust/indicatif-0.17
	>=dev-rust/linux-embedded-hal-0.3.1:= <dev-rust/linux-embedded-hal-0.4
	>=dev-rust/num_enum-0.5.1:= <dev-rust/num_enum-0.6.0
	=dev-rust/nb-1*:=
	=dev-rust/panic-halt-0.2*:=
	=dev-rust/panic-reset-0.1*:=
	=dev-rust/riscv-0.7*:=
	=dev-rust/riscv-rt-0.8*:=
	>=dev-rust/rusb-0.8.1:= <dev-rust/rusb-0.9
	=dev-rust/rustyline-9*:=
	>=dev-rust/serialport-4.0.1:= <dev-rust/serialport-5
	>=dev-rust/simple_logger-1.13.0:= <dev-rust/simple_logger-2
	>=dev-rust/spi-memory-0.2.0:= <dev-rust/spi-memory-0.3.0
	=dev-rust/stm32g0xx-hal-0.1*:=
	=dev-rust/ufmt-0.1*:=
	=dev-rust/ufmt-write-0.1*:=
	>=dev-rust/panic-rtt-target-0.1.2:= <dev-rust/panic-rtt-target-0.2.0
	>=dev-rust/rtt-target-0.3.1:= <dev-rust/rtt-target-0.4.0
"

# /usr/lib/firmware/hps/fpga_bitstream.bin and
# /usr/lib/firmware/hps/fpga_application.bin
# moved from hps-firmware-images to here
RDEPEND="
	!<chromeos-base/hps-firmware-images-0.0.1-r17
"

src_unpack() {
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_prepare() {
	# Not using cros-rust_src_prepare because it wrongly assumes Cargo.toml is
	# in the root of ${S} and we don't need its manipulations anyway.

	# Delete some optional dependencies that are not packaged in Chromium OS.
	sed -i \
		-e '/ optional = true/d' \
		-e '/^direct /d' \
		rust/hps-mon/Cargo.toml

	default
}

src_configure() {
	# Use Python helper modules from CFU-Playground. These are developed
	# upstream but are intimately tied to the HPS accelerator code.
	export PYTHONPATH="${S}/third_party/python/CFU-Playground"

	# Use Rust and GCC from hps-sdk, since the main Chrome OS compilers
	# do not yet support RISC-V.
	export PATH="/opt/hps-sdk/bin:${PATH}"

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
	# shellcheck disable=SC2154 # ECARGO_HOME is defined in cros-rust.eclass
	cat <<- EOF >> "${ECARGO_HOME}/config"
	[target.'cfg(all(target_arch = "arm", target_os = "none"))']
	rustflags = [
		"-Clto=yes",
		"-Copt-level=z",
		"-Coverflow-checks=off",
		"-Cdebug-assertions=off",
		"-Ccodegen-units=1",
	]
	EOF

	# cros-rust_update_cargo_lock tries to handle Cargo.lock but it assumes
	# there is only one Cargo.lock in the root of the source tree, which is not
	# true for hps-firmware. For now just delete the ones we have.
	rm rust/Cargo.lock rust/mcu/Cargo.lock rust/riscv/Cargo.lock
}

src_compile() {
	# Build FPGA bitstream
	einfo "Building FPGA bitstream"
	python -m soc.hps_soc --build --no-compile-software || die

	# Build FPGA application
	einfo "Building FPGA application"
	(
		cd rust/riscv/fpga_rom || die
		ecargo build --release
	)
	# shellcheck disable=SC2154 # CARGO_TARGET_DIR is defined in cros-rust.eclass
	llvm-objcopy -O binary \
		"${CARGO_TARGET_DIR}/riscv32i-unknown-none-elf/release/fpga_rom" \
		"${S}/build/hps_platform/fpga_rom.bin" || die

	# Build signing tool for the build host, so that we can use it below
	(
		cd rust/sign-rom || die
		einfo "Building sign-rom for build host"
		# TODO(b/218953559): this should be --target=$CBUILD, fix hps-sdk
		ecargo build --target=x86_64-unknown-linux-gnu --release
	)

	# Build MCU firmware
	for crate in stage0 stage1_app ; do (
		einfo "Building MCU firmware ${crate}"
		cd rust/mcu/${crate} || die
		HPS_SPI_BIT="${S}/build/hps_platform/gateware/hps_platform.bit" \
			HPS_SPI_BIN="${S}/build/hps_platform/fpga_rom.bin" \
			ecargo build \
			--target="thumbv6m-none-eabi" \
			--release
		einfo "Flattening MCU firmware image ${crate}"
		# shellcheck disable=SC2154 # CARGO_TARGET_DIR is defined in cros-rust.eclass
		llvm-objcopy -O binary \
			"${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/${crate}" \
			"${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/${crate}.bin" || die
	) done

	# Sign MCU stage1 firmware with dev key
	# shellcheck disable=SC2154 # CARGO_TARGET_DIR is defined in cros-rust.eclass
	"${CARGO_TARGET_DIR}/x86_64-unknown-linux-gnu/release/sign-rom" \
		--input "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin" \
		--output "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin.signed" \
		--use-insecure-dev-key \
		|| die
}

src_test() {
	einfo "Running gateware unit tests"
	python -m unittest -v soc/*.py || die

	einfo "Running Rust tests"
	cd rust || die
	RUST_BACKTRACE=1 ecargo_test
}

src_install() {
	# Extract stage1 version (currently this is just the first 4 bytes of the
	# stage1 signature).
	# shellcheck disable=SC2154 # CARGO_TARGET_DIR is defined in cros-rust.eclass
	python3 -c "with open('${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin.signed', 'rb') as f:
		f.seek(20);
		print(int.from_bytes(f.read(4), 'big'))" \
		>mcu_stage1.version.txt || die

	# install build metadata for use by:
	# https://source.corp.google.com/chromeos_internal/src/platform/tast-tests-private/src/chromiumos/tast/local/bundles/crosint/hps/fpga_gateware_stats.go
	insinto "/usr/lib/firmware/hps"
	doins build/hps_platform/gateware/hps_platform_build.metadata

	# Generate and install the build manifest.
	# shellcheck disable=SC2154 # VCSID is supplied by cros-workon.eclass
	echo "${VCSID}" > manifest.txt
	cat models/manifest.txt >> manifest.txt

	# install into /firmware as part of signing process
	# signed release firmware is installed by hps-firmware-images ebuild
	insinto "/firmware/hps"
	# shellcheck disable=SC2154 # CARGO_TARGET_DIR is defined in cros-rust.eclass
	newins "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage0.bin" "mcu_stage0.bin"
	newins "${CARGO_TARGET_DIR}/thumbv6m-none-eabi/release/stage1_app.bin.signed" "mcu_stage1.bin"
	doins mcu_stage1.version.txt
	doins manifest.txt
	newins build/hps_platform/gateware/hps_platform.bit fpga_bitstream.bin
	newins build/hps_platform/fpga_rom.bin fpga_application.bin
}
