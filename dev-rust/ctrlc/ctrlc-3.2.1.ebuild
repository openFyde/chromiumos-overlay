# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1
CROS_RUST_REMOVE_TARGET_CFG=1

inherit cros-rust

DESCRIPTION='Easy Ctrl-C handler for Rust projects'
HOMEPAGE='https://github.com/Detegr/rust-ctrlc'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/nix-0.23*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
