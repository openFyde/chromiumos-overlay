# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='A generator library used with clap for Fig completion scripts'
HOMEPAGE='https://crates.io/crates/clap_complete_fig'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/clap-3.1.10 <dev-rust/clap-4.0.0_alpha:=
	>=dev-rust/clap_complete-3.1.2 <dev-rust/clap_complete-4.0.0_alpha:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
