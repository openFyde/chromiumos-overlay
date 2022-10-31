# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f67c800410b4240761f8a12c45b3b2f05be22855"
CROS_WORKON_TREE="cf1f756b88c4cbb25e1a6d47c4eed462c47f4b03"
CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware"
CROS_WORKON_LOCALNAME="platform/hps-firmware2"
CROS_RUST_SUBDIR="rust/sign-rom"

inherit cros-workon cros-rust

DESCRIPTION="Tool to sign HPS firmware"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	>=dev-rust/anyhow-1.0.38 <dev-rust/anyhow-2.0.0
	=dev-rust/bindgen-0.59*
	=dev-rust/clap-3*
	>=dev-rust/cortex-m-0.6.2 <dev-rust/cortex-m-0.7.0
	>=dev-rust/cortex-m-rtic-1.1.3 <dev-rust/cortex-m-rtic-2.0.0
	>=dev-rust/embedded-hal-0.2.4 <dev-rust/embedded-hal-0.3.0
	=dev-rust/embedded-hal-mock-0.8*
	>=dev-rust/ftdi-0.1.3 <dev-rust/ftdi-0.2
	>=dev-rust/image-0.23.14 <dev-rust/image-0.24
	>=dev-rust/linux-embedded-hal-0.3.1 <dev-rust/linux-embedded-hal-0.4
	>=dev-rust/num_enum-0.5.1 <dev-rust/num_enum-0.6.0
	=dev-rust/nb-1*
	=dev-rust/riscv-rt-0.8*
	>=dev-rust/rusb-0.8.1 <dev-rust/rusb-0.9
	>=dev-rust/simple_logger-1.13.0 <dev-rust/simple_logger-2
	>=dev-rust/spi-memory-0.2.0 <dev-rust/spi-memory-0.3.0
	=dev-rust/stm32g0xx-hal-0.1*
	>=dev-rust/rtt-target-0.3.1 <dev-rust/rtt-target-0.4.0
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
