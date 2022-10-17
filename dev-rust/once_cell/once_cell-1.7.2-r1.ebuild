# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Single assignment cells and lazy values."
HOMEPAGE="https://github.com/matklad/once_cell"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

# Note that we don't (yet) depend directly on third-party-crates-src, but
# `third-party-crates-src` _does_ emerge a package which is a semver-compatible
# upgrade of this. In order for transitive dependencies of this package to not
# race with its installation, we need a DEPEND on it here.
DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-Remove-optional-dependencies.patch"
)
