# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Compile the git version (tag name, or hash otherwise) and dirty state into your program.'
HOMEPAGE='https://crates.io/crates/git-version'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="BSD-2"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	~dev-rust/git-version-macro-0.3.5:=
	=dev-rust/proc-macro-hack-0.5*:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

# error: could not compile `git-version`
RESTRICT="test"
