# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="C++ code generator for integrating 'cxx' crate into a non-Cargo build."
HOMEPAGE="https://crates.io/crates/cxxbridge-cmd"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/codespan-reporting-0.11*
"

# Package was briefly installed at slot 1.0.42. We don't want that.
RDEPEND="${DEPEND}
	!dev-util/cxxbridge-cmd:1.0.42
"

# This file was automatically generated by cargo2ebuild.py
# All changes below are manual

src_compile() {
	ecargo_build
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/cxxbridge"
}
