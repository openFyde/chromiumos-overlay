# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Rayon is a data-parallelism library for Rust"
HOMEPAGE="https://github.com/rayon-rs/rayon"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"
IUSE="cros_host"

DEPEND="dev-rust/third-party-crates-src:="

# Ensure that rayon deps are installed by default in SDK
# to avoid re-installs at chroot creation time.
RDEPEND="cros_host? ( ${DEPEND} )"

# could not compile
RESTRICT="test"
