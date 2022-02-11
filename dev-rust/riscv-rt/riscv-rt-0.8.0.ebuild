# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION='Minimal runtime / startup for RISC-V CPUs'
HOMEPAGE='https://crates.io/crates/riscv-rt'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="ISC"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/panic-halt-0.2*:=
	=dev-rust/r0-1*:=
	=dev-rust/riscv-0.7*:=
	>=dev-rust/riscv-rt-macros-0.1.6 <dev-rust/riscv-rt-macros-0.2.0_alpha:=
	>=dev-rust/riscv-target-0.1.2 <dev-rust/riscv-target-0.2.0_alpha:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	cros-rust_src_prepare
	git apply "${FILESDIR}/riscv-rt-0.8.0-update-to-riscv-0.7.patch"
}

src_test() {
	# This crate can only be compiled for RISC-V targets. There are no tests.
	:
}

src_install() {
	cros-rust_src_install

	# Do not strip prebuilt .a files in the crate sources
	# shellcheck disable=SC2154 # CROS_RUST_REGISTRY_BASE is defined in cros-rust.eclass
	dostrip -x "${CROS_RUST_REGISTRY_BASE}"
}

# Suppress QA warnings for prebuilt .a files in the crate sources
# shellcheck disable=SC2154 # CROS_RUST_REGISTRY_BASE is defined in cros-rust.eclass
QA_EXECSTACK="${CROS_RUST_REGISTRY_BASE#/}/*"
