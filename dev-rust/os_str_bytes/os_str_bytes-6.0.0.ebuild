# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Utilities for converting between byte sequences and platform-native strings'
HOMEPAGE='https://crates.io/crates/os_str_bytes'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/memchr-2.4.0 <dev-rust/memchr-3.0.0_alpha
	=dev-rust/print_bytes-0.5*
	=dev-rust/uniquote-3*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
