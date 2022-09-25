# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Locate installed executable in cross platforms."
HOMEPAGE="https://github.com/harryfei/which-rs.git"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	>=dev-rust/either-1.6.0 <dev-rust/either-2.0.0
	=dev-rust/lazy_static-1*
	>=dev-rust/regex-1.5.4 <dev-rust/regex-2.0.0
"
RDEPEND="${DEPEND}"

# error: could not compile `which`
RESTRICT="test"
