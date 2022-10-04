# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Attributes re-exported in "riscv-rt"'
HOMEPAGE='https://crates.io/crates/riscv-rt-macros'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	>=dev-rust/rand-0.7.3 <dev-rust/rand-0.8.0_alpha
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/riscv-rt-macros-0.1.6-update-dependencies.patch"
)
