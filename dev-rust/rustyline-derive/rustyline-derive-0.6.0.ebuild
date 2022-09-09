# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Rustyline macros implementation of #[derive(Completer, Helper, Hinter, Highlighter)]'
HOMEPAGE='https://crates.io/crates/rustyline-derive'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/quote-1*
	=dev-rust/syn-1*
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
