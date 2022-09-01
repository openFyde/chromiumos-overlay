# Copyright 2022 The Chromium OS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="4d6c257ade770c34ec59e0279c8a3654dbba4868"
CROS_WORKON_TREE="c2383e1e84ecdff21ab530d77e65e0db7279906e"
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
	~dev-rust/clap-3.0.0_beta2:=
	=dev-rust/colored-2*:=
	>=dev-rust/cortex-m-0.6.2:= <dev-rust/cortex-m-0.7.0
	>=dev-rust/cortex-m-rt-0.6.13:= <dev-rust/cortex-m-rt-0.7.0
	>=dev-rust/cortex-m-rtic-1.1.3:= <dev-rust/cortex-m-rtic-2.0.0
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
	>=dev-rust/log-0.4.14:= <dev-rust/log-0.5
	>=dev-rust/num_enum-0.5.1:= <dev-rust/num_enum-0.6.0
	=dev-rust/nb-1*:=
	=dev-rust/panic-halt-0.2*:=
	=dev-rust/panic-reset-0.1*:=
	=dev-rust/riscv-0.7*:=
	=dev-rust/riscv-rt-0.8*:=
	>=dev-rust/rusb-0.8.1:= <dev-rust/rusb-0.9
	=dev-rust/rustyline-9*:=
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
	# config.toml is intended for use when running `cargo` directly but would
	# mess with the ebuild if we didn't delete it.
	rm -f ../.cargo/config.toml

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
