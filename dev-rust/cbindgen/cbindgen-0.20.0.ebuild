# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A tool for generating C bindings to Rust code.'
HOMEPAGE='https://crates.io/crates/cbindgen'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MPL-2.0"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/clap-2*
	=dev-rust/indexmap-1*
	=dev-rust/log-0.4*
	=dev-rust/quote-1*
	>=dev-rust/serde-1.0.103 <dev-rust/serde-2.0.0_alpha
	=dev-rust/serde_json-1*
	>=dev-rust/syn-1.0.3 <dev-rust/syn-2.0.0_alpha
	=dev-rust/tempfile-3*
	=dev-rust/toml-0.5*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
