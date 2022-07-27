# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A non-cryptographic hash function using AES-NI for high performance'
HOMEPAGE='https://crates.io/crates/ahash'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

# We need the local patch until upstream has fix for the following issue:
# https://github.com/tkaitchuck/aHash/issues/117
PATCHES=(
	"${FILESDIR}/${PN}-${PV}-rm-features.patch"
)

DEPEND="
	=dev-rust/version_check-0.9*:=
	>=dev-rust/const-random-0.1.12 <dev-rust/const-random-0.2.0_alpha:=
	>=dev-rust/getrandom-0.2.3 <dev-rust/getrandom-0.3.0_alpha:=
	>=dev-rust/serde-1.0.117 <dev-rust/serde-2.0.0_alpha:=
	>=dev-rust/once_cell-1.8.0 <dev-rust/once_cell-2.0.0_alpha:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
