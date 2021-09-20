# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Internal macro crate for git-version.'
HOMEPAGE='https://crates.io/crates/git-version-macro'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="BSD-2"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/proc-macro-hack-0.5*:=
	=dev-rust/proc-macro2-1*:=
	=dev-rust/quote-1*:=
	=dev-rust/syn-1*:=
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py

# thread 'utils::test_git_dir' panicked at 'called `Result::unwrap()` on an `Err` value: Custom { kind: Other, error: "git rev-parse --git-dir failed with status 128: fatal: not a git repository (or any of the parent directories): .git" }', src/utils.rs:52:23
RESTRICT="test"
