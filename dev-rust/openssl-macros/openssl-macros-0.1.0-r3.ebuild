# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Internal macros used by the openssl crate."
HOMEPAGE="https://github.com/sfackler/rust-openssl"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are
# pulled in when installing binpkgs since the full source tree is required to
# use the crate.
RDEPEND="${DEPEND}
	!=dev-rust/openssl-macros-0.1*
"
