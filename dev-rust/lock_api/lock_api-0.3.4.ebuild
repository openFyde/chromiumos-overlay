# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="Wrappers to create fully-featured Mutex and RwLock types. Compatible with no_std."
HOMEPAGE="https://crates.io/crates/lock_api"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/owning_ref-0.4*:=
	=dev-rust/scopeguard-1*:=
	>=dev-rust/serde-1.0.90:= <dev-rust/serde-2.0.0
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
