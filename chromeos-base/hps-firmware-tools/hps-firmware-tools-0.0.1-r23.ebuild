# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="025f9879f83c3c993456f2e7ca45c4331732e73e"
CROS_WORKON_TREE="179a762714e0079fa27a7400b33677dc5a292066"
CROS_WORKON_PROJECT="chromiumos/platform/hps-firmware"
CROS_WORKON_LOCALNAME="platform/hps-firmware2"

inherit cros-workon cros-rust

DESCRIPTION="HPS firmware tools for development and testing"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware"

LICENSE="BSD-Google"
KEYWORDS="*"

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
	=dev-rust/ed25519-compact-1*:=
	>=dev-rust/embedded-hal-0.2.4:= <dev-rust/embedded-hal-0.3.0
	=dev-rust/embedded-hal-mock-0.8*:=
	>=dev-rust/hmac-sha256-0.1.6:= <dev-rust/hmac-sha256-0.2.0
	>=dev-rust/image-0.23.14:= <dev-rust/image-0.24
	>=dev-rust/linux-embedded-hal-0.3.1:= <dev-rust/linux-embedded-hal-0.4
	>=dev-rust/num_enum-0.5.1:= <dev-rust/num_enum-0.6.0
	=dev-rust/nb-1*:=
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
"

# host tools used to live in hps-firmware
RDEPEND="
	!<chromeos-base/hps-firmware-0.1.0-r244
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
	cros-rust_configure_cargo

	# cros-rust_update_cargo_lock tries to handle Cargo.lock but it assumes
	# there is only one Cargo.lock in the root of the source tree, which is not
	# true for hps-firmware. For now just delete the ones we have.
	rm rust/Cargo.lock rust/mcu/Cargo.lock rust/riscv/Cargo.lock
}

src_compile() {
	for tool in hps-mon hps-util sign-rom ; do (
		cd rust/${tool} || die
		einfo "Building ${tool}"
		ecargo_build
	) done
}

src_test() {
	# TODO invoke ecargo_test once we have complete workspace deps satisfied
	:
}

src_install() {
	newbin "$(cros-rust_get_build_dir)/sign-rom" hps-sign-rom
	dobin "$(cros-rust_get_build_dir)/hps-mon"
	dobin "$(cros-rust_get_build_dir)/hps-util"
}
