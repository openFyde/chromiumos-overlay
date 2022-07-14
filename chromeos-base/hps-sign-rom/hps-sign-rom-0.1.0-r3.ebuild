# Copyright 2022 The Chromium OS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="b86b9336938f20b899fe8485bf330c3724ecfcca"
CROS_WORKON_TREE="5a0d91d26df2520d172d1e2736f98e5c5baf1395"
CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware"
CROS_WORKON_LOCALNAME="platform/hps-firmware2"
CROS_RUST_SUBDIR="rust/sign-rom"

inherit cros-workon cros-rust

DESCRIPTION="Tool to sign HPS firmware"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware"

LICENSE="BSD-Google"
KEYWORDS="*"

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

# /usr/bin/hps-sign-rom moved from hps-firmware-tools to here
RDEPEND="
	!<chromeos-base/hps-firmware-tools-0.0.1-r141
"

src_prepare() {
	# Delete some optional dependencies that are not packaged in ChromiumOS.
	sed -i \
		-e '/ optional = true/d' \
		-e '/^direct /d' \
		../hps-mon/Cargo.toml

	cros-rust_src_prepare
}

src_test() {
	# All Rust unit tests (including the ones for sign-rom)
	# are executed by src_test in the hps-firmware package.
	# Nothing else to do here.
	:
}

src_install() {
	newbin "$(cros-rust_get_build_dir)/sign-rom" hps-sign-rom
}
