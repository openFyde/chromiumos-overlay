# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION='Automatic property based testing with shrinking.'
HOMEPAGE='https://github.com/BurntSushi/quickcheck'
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="MIT"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/env_logger-0.5*:=
	=dev-rust/log-0.4*:=
	=dev-rust/rand-0.5*:=
	>=dev-rust/rand_core-0.2.1:= <dev-rust/rand_core-0.3.0
"
RDEPEND="${DEPEND}"

# This file was automatically generated by cargo2ebuild.py
