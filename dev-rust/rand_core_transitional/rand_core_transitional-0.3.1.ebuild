# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cros-rust

RUST_CRATE="rand_core"
DESCRIPTION="Transitional package for ${RUST_CRATE}"
HOMEPAGE="https://github.com/rust-random/rand"
SRC_URI="https://crates.io/api/v1/crates/${RUST_CRATE}/${PV}/download -> ${RUST_CRATE}-${PV}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

S="${WORKDIR}/${RUST_CRATE}-${PV}"

DEPEND="
	~dev-rust/rand_core-0.4.0:=
"

src_install() {
	cros-rust_publish "${RUST_CRATE}"
}
