# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="This crate aims to make error reporting in proc-macros simple and easy to use"
HOMEPAGE="https://gitlab.com/CreepySkeleton/proc-macro-error"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/proc-macro2-1*
	~dev-rust/proc-macro-error-attr-1.0.4
	=dev-rust/quote-1*
	=dev-rust/syn-1*
	=dev-rust/version_check-0.9*
"

# compile failed
RESTRICT="test"
