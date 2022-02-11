# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Low level access to RISC-V processors'
HOMEPAGE='https://crates.io/crates/riscv'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="ISC"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/bare-metal-1*:=
	=dev-rust/bit_field-0.10*:=
	>=dev-rust/riscv-target-0.1.2 <dev-rust/riscv-target-0.2.0_alpha:=
"
RDEPEND="${DEPEND}"

src_install() {
	cros-rust_src_install

	# Do not strip prebuilt .a files in the crate sources
	# shellcheck disable=SC2154 # CROS_RUST_REGISTRY_BASE is defined in cros-rust.eclass
	dostrip -x "${CROS_RUST_REGISTRY_BASE}"
}

# Suppress QA warnings for prebuilt .a files in the crate sources
# shellcheck disable=SC2154 # CROS_RUST_REGISTRY_BASE is defined in cros-rust.eclass
QA_EXECSTACK="${CROS_RUST_REGISTRY_BASE#/}/*"
