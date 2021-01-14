# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="C++ code generator for integrating cxx crate into a non-Cargo build."
HOMEPAGE="https://docs.rs/crate/cxxbridge-cmd"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0/0"
KEYWORDS="*"

DEPEND="
	>=dev-rust/clap-2.33:= <dev-rust/clap-3
	=dev-rust/codespan-reporting-0.9*:=
	>=dev-rust/proc-macro2-1.0.17:= <dev-rust/proc-macro2-2
	=dev-rust/quote-1*:=
	>=dev-rust/syn-1.0.57:= <dev-rust/syn-2
"

src_unpack() {
	cros-rust_src_unpack

	# Cargo.lock and Cargo.toml disagree about the version of proc-macro2 and
	# syn so just delete the lock file.
	rm -vf "${S}/Cargo.lock"
}

src_compile() {
	ecargo_build
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/cxxbridge"
}
