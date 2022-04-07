# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Minimal runtime / startup for Cortex-M microcontrollers'
HOMEPAGE='https://crates.io/crates/cortex-m-rt'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	~dev-rust/cortex-m-rt-macros-0.6.15:=
	>=dev-rust/r0-0.2.2 <dev-rust/r0-0.3.0_alpha:=
"
RDEPEND="${DEPEND}"

src_test() {
	# This crate can only be compiled for Cortex-M targets. There are no unit tests.
	# The crate *is* configured for compile-testing, see for example:
	# https://github.com/rust-embedded/cortex-m/blob/master/cortex-m-rt/ci/script.sh
	# but that requires some dependencies which are not yet packaged in Chrome OS.
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
