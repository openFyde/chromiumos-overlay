# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="C++ code generator for integrating 'cxx' crate into a non-Cargo build."
HOMEPAGE="https://crates.io/crates/cxxbridge-cmd"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/clap-2.33:= <dev-rust/clap-3.0.0_alpha
	>=dev-rust/codespan-reporting-0.11:= <dev-rust/codespan-reporting-0.12.0_alpha
	>=dev-rust/proc-macro2-1.0.26:= <dev-rust/proc-macro2-2.0.0_alpha
	>=dev-rust/quote-1.0:= <dev-rust/quote-2.0.0_alpha
	>=dev-rust/syn-1.0.68:= <dev-rust/syn-2.0.0_alpha
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
# All changes below are manual

src_compile() {
	ecargo_build
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/cxxbridge"
}
