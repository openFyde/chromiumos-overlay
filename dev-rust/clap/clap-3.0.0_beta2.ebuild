# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A simple to use, efficient, and full-featured Command Line Argument Parser'
HOMEPAGE='https://clap.rs/'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/atty-0.2*:=
	>=dev-rust/bitflags-1.2.0:= <dev-rust/bitflags-2.0.0
	=dev-rust/clap_derive-3.0.0_beta2:=
	=dev-rust/indexmap-1*:=
	=dev-rust/lazy_static-1*:=
	>=dev-rust/os_str_bytes-2.3.0:= <dev-rust/os_str_bytes-3.0.0
	=dev-rust/regex-1*:=
	=dev-rust/strsim-0.10*:=
	>=dev-rust/termcolor-1.1.0:= <dev-rust/termcolor-2.0.0
	>=dev-rust/terminal_size-0.1.12:= <dev-rust/terminal_size-0.2.0
	=dev-rust/textwrap-0.12*:=
	=dev-rust/unicode-width-0.1*:=
	=dev-rust/vec_map-0.8*:=
	>=dev-rust/yaml-rust-0.4.1:= <dev-rust/yaml-rust-0.5.0
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
# ${PV} was changed from the original 3.0.0-beta.2

CROS_RUST_CRATE_VERSION="3.0.0-beta.2"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${CROS_RUST_CRATE_VERSION}/download -> ${P}.crate"
S="${WORKDIR}/${PN}-${CROS_RUST_CRATE_VERSION}"

IUSE="test"
TEST_DEPS="
	test? (
		=dev-rust/criterion-0.3.2:=
		=dev-rust/version-sync-0.8*:=
	)
"
DEPEND+="${TEST_DEPS}"
RDEPEND+="${TEST_DEPS}"

src_prepare() {
	if use test; then
		CROS_RUST_REMOVE_DEV_DEPS=0
	fi
	cros-rust_src_prepare
}
